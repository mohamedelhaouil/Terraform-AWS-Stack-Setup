variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PRIV_KEY" {
  default = "AWSstack1key"
}

variable "PUB_KEY" {
  default = "AWSstack1key.pub"
}

variable "Zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "MY_IP" {
  default = "0.0.0.0/0"
}

variable "VpcNAME" {
  default = "AWS-Stack-VPC"
}

variable "VpcCIDR" {
  default = "172.21.0.0/16"
}

variable "PubSubnetCIDR" {
  type    = list(string)
  default = ["172.21.1.0/24", "172.21.2.0/24", "172.21.3.0/24"]
}

variable "PrivSubnetCIDR" {
  type    = list(string)
  default = ["172.21.4.0/24", "172.21.5.0/24", "172.21.6.0/24"]
}

variable "USERNAME" {
  default = "ubuntu"
}

variable "rmquser" {
  default = "rabbit"
}

variable "rmqpass" {
  sensitive = true
}

variable "dbuser" {
  default = "admin"
}

variable "dbpass" {
  sensitive = true
}

variable "dbname" {
  default = "accounts"
}