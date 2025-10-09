output "aws_account" {
  description = "Account ID of the AWS account to use as spec.aws.account of your cloud access"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_role_arn" {
  description = "ARN of the IAM role to use as spec.aws.roleArn of your cloud access"
  value       = aws_iam_role.role.arn
}
