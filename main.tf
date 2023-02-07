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
resource "circleci_additional_ssh_key" "this" {
  project_slug = "gh/Gadom654/learn-terraform-circleci"
  hostname = "none"
  private_key   = file("id_rsa_86:f4:a9:08:e4:76:5f:15:35:04:a8:a6:a5:b5:4a:be")
}
resource "aws_key_pair" "main" {
  key_name_prefix = "id_rsa-"
  public_key      = file(var.public_key_file)
}
