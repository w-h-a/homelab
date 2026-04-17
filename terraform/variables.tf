variable "do_token" {
  type      = string
  sensitive = true
}

variable "name" {
  type    = string
  default = "homelab"
}

variable "region" {
  type    = string
  default = "sfo3"
}

variable "k8s_version" {
  type    = string
  default = "1.35"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "node_size" {
  type    = string
  default = "s-2vcpu-4gb-amd"
}
