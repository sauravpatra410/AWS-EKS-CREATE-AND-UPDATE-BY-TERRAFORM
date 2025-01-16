cluster_name       = "prod-cluster"
instance_count     = 2
instance_size      = "t2.small"
region             = "ap-south-1"
cluster_version    = "1.30" # 1.31
ami_id             = "ami-003c0d8931dc3f095"#"ami-006a84b3ee80138d1" #ami-0cfd96d646e5535a8
vpc-cni-version    = "v1.19.2-eksbuild.1"#"v1.19.2-eksbuild.1" #v1.18.2-eksbuild.1
kube-proxy-version = "v1.30.7-eksbuild.2"#"v1.29.11-eksbuild.2" 