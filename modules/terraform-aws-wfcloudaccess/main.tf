locals {
  resource_suffix   = var.resource_suffix != "" ? "-${var.resource_suffix}" : ""
}

data "aws_caller_identity" "current" {}

data "http" "openid-configuration" {
  count = var.provision_oidc_trust ? 1 : 0

  url = "https://${var.oidc_issuer}/.well-known/openid-configuration"

  lifecycle {
    precondition {
      condition     = var.oidc_issuer != ""
      error_message = "Must specify oidc_issuer to enable OIDC trust for Wayfinder to AWS"
    }
  }
}

data "tls_certificate" "jwks" {
  count = var.provision_oidc_trust ? 1 : 0

  url = jsondecode(data.http.openid-configuration[0].response_body).jwks_uri
}

resource "aws_iam_openid_connect_provider" "wf-trust" {
  count = var.provision_oidc_trust ? 1 : 0

  client_id_list = [var.oidc_audience]
  url            = "https://${var.oidc_issuer}"
  tags           = var.tags

  thumbprint_list = [
    # This should give us the certificate of the top intermediate CA in the certificate authority chain
    one(
      [
        for cert in data.tls_certificate.jwks[0].certificates :
        cert
        if cert.is_ca
      ]
    ).sha1_fingerprint,
  ]

  lifecycle {
    precondition {
      condition     = var.oidc_issuer != "" && var.oidc_audience != ""
      error_message = "Must specify oidc_issuer and oidc_audience to enable OIDC trust for Wayfinder to AWS"
    }
  }
}

data "aws_iam_policy_document" "assume_role_with_oidc" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_issuer}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_issuer}:sub"
      values   = [var.oidc_subject]
    }
  }
}

resource "aws_iam_role" "role" {
  name                 = "${var.iam_role_name}${var.resource_suffix}"
  description          = "Wayfinder IAM role"

  permissions_boundary = var.role_permissions_boundary_arn

  assume_role_policy = data.aws_iam_policy_document.assume_role_with_oidc.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "policy_assignments" {
  for_each = { for idx, role in var.policy_assignments : idx => role }

  role       = aws_iam_role.role.name
  policy_arn = each.value
}
