variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "public_key" {
  type = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "vpc_id" {
  type = string
}
