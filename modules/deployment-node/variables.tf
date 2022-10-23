variable "ami_id" {
  type        = string
  description = "ami id identifying the type of instance"
  default     = "ami-03a68febd9b9a5403"
}

variable "subnet_id" {
  type        = string
  description = "subnet id identifying the type of instance"
}

variable "vpc_id" {
  type        = string
  description = "subnet id identifying the type of instance"
}

variable "security_group_ids" {
  type        = list(string)
  description = "ids of all the security groups to associate to the vm"
}

variable "key_name" {
  type        = string
  description = "the keypair to ssh into the machine"
}

variable "alb_arn" {
  type        = string
  description = "the arn of the load balancer"
}
