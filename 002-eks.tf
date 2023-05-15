module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = local.cluster_name
  cluster_version = local.eks_version

  vpc_id                          = module.vpc.vpc_id
  subnets                         = module.vpc.private_subnets
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_create_security_group   = true

    map_users = [
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/candidate1"
        username = "devops_admin_role"
        groups   = ["system:masters"]
      }
    ]
  worker_groups_launch_template = [
    {
      name                 = "worker-group-1"
      instance_type        = "t3.small"
      asg_desired_capacity = 1
      public_ip            = true
    },
    {
      name                 = "worker-group-2"
      instance_type        = "t3.medium"
      asg_desired_capacity = 1
      public_ip            = true
      ebs_optimized        = true
    },
    {
      name                   = "worker-group-4"
      instance_type          = "t3.small"
      asg_desired_capacity   = 1
      public_ip              = true
      root_volume_size       = 150
      root_volume_type       = "gp3"
      root_volume_throughput = 300
      additional_ebs_volumes = [
        {
          block_device_name = "/dev/xvdb"
          volume_size       = 100
          volume_type       = "gp3"
          throughput        = 150
        },
      ]
    },
  ]

  tags = merge(
  tomap({ "EKS_Cluster_Name" = local.cluster_name }),
  local.extra_tags
  )
}
