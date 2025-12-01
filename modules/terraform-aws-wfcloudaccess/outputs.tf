output "aws_account" {
  description = "Account ID of the AWS account to use as spec.aws.account of your cloud access"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_role_arn" {
  description = "ARN of the IAM role to use as spec.aws.roleArn of your cloud access"
  value       = aws_iam_role.role.arn
}

output "state_store_bucket" {
  description = "Name of the S3 bucket for state storage (for use in spec.stateStore.awsS3.bucket)"
  value       = var.enable_state_store ? aws_s3_bucket.state_store[0].id : null
}
