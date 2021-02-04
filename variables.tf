variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "tenancy" {
  default = "default"
}

variable "tags" {
  default = {
    Name = "my-vpc"
  }
}