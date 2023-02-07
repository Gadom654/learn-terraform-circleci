provider "aws" {
  region = var.region
}

module "cluster_1" {
  source       = "weibeld/kubeadm/aws"
  version      = "~> 0.2"
  cluster_name = var.cluster_names[0]
}

module "cluster_2" {
  source       = "weibeld/kubeadm/aws"
  version      = "~> 0.2"
  cluster_name = var.cluster_names[1]
}

module "cluster_3" {
  source       = "weibeld/kubeadm/aws"
  version      = "~> 0.2"
  cluster_name = var.cluster_names[2]
}

resource "aws_key_pair" "main" {
  key_name_prefix = "id_rsa-"
  public_key      = file(var.public_key_file)
}
