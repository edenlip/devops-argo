locals {
  aws_region = "us-west-2"

  cluster_name = "devops-test"

  eks_version = "1.22"

  extra_tags = {
    TerraformManaged = "True"
    Environment      = local.env_name
  }

  env_name = "devops-test"

}
