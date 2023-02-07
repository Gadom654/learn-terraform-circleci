variable "cluster_names" {
  type        = tuple([string, string, string])
  description = "Names for the individual clusters. If the value for a specific cluster is null, a random name will be automatically chosen."
  default     = [null, null, null]
}

variable "region" {
  type        = string
  description = "AWS region in which to create the clusters."
  default     = "eu-central-1"
}
variable "private_key_file" {
  type        = string
  description = "Filename of the private key of a key pair on your local machine. This key pair will allow to connect to the nodes of the cluster with SSH."
  default     = "~/.ssh/id_rsa_86:f4:a9:08:e4:76:5f:15:35:04:a8:a6:a5:b5:4a:be"
}

variable "public_key_file" {
  type        = string
  description = "Filename of the public key of a key pair on your local machine. This key pair will allow to connect to the nodes of the cluster with SSH."
  default     = "~/.ssh/id_rsa_86:f4:a9:08:e4:76:5f:15:35:04:a8:a6:a5:b5:4a:be.pub"
}
