 
 variable "compute_ami" {
     description = "The ami for development with compute and cpu"
     type = string
     default = "ami-0440d3b780d96b29d"
 }

 variable "compute_type" {
      description = "The ec2 type for development with compute and cpu"
      type = string
      default = "r6i.xlarge"
  }
  
 variable "model_ami" {
     description = "The ami for development using a model"
     type = string
     default = "ami-02a7c8161f9fe6705"
 }

 variable "model_type" {
      description = "The ec2 type for development using a model"
      type = string
      default = "g4dn.xlarge"
 }

 variable "private_subnet_A" {
     description = "The subnet for development on private subnet zone A"
     type = string
     default = "subnet-0286aca0ed3318643"
 }

  variable "public_subnet_A" {
     description = "The subnet for development on public subnet zone A"
     type = string
     default = "subnet-05612dfc6e545f302"
 }

 variable "bastion_ami" {
     description = "The ami for development with a bastion"
     type = string
     default = "ami-0440d3b780d96b29d"
 }

 variable "bastion_type" {
      description = "The ec2 type for development with a bastion"
      type = string
      default = "t2.micro"
 }
 