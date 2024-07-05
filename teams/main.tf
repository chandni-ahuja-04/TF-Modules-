module "vpc" {
  source = "../modules/vpc"
  vpc_cidr    = "10.0.0.0/16"
  subnet_pu_1 = "10.0.0.0/24"
  subnet_pu_2 = "10.0.1.0/24"
  subnet_pr_1 = "10.0.2.0/24"
  subnet_pr_2 = "10.0.3.0/24"
  zone1       = "us-east-1a"
  zone2       = "us-east-1b"
  route_cidr  = "0.0.0.0/0"
}