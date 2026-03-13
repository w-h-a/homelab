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

variable "node_cpu" {
  type    = list(number)
  default = [2]
}

variable "node_memory" {
  type    = list(number)
  default = [4096]
}
