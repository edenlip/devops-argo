output "prod_eks_cluster" {
  value     = module.eks
  sensitive = true
}

output "developer_credentials_secret" {
  value     = aws_iam_access_key.developer_access_key.secret
  sensitive = true
}

output "developer_credentials_id" {
  value     = aws_iam_access_key.developer_access_key.id
  sensitive = true
}
