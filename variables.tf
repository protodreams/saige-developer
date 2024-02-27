 
 variable "compute_ami" {
     description = "The ami for development with compute and cpul"
     type = string
     default = "ami-0440d3b780d96b29d"
 }

 variable "compute_type" {
      description = "The ec2 type for development with compute and cpul"
      type = string
      default = "r6i.xlarge"
  }
  
 variable "model_ami" {
     description = "The ami for development using a model"
     type = string
     default = "ami-079ce88a030285488"
 }

 variable "model_type" {
      description = "The ec2 type for development using a model"
      type = string
      default = "g4dn.xlarge"
 }

 variable "private_subnet_A" {
     description = "The subnet for development on private subnet zone A"
     type = string
     default = "subnet-018ca37d59f7542d6"
 }

  variable "public_subnet_A" {
     description = "The subnet for development on public subnet zone A"
     type = string
     default = "subnet-018ca37d59f7542d6"
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
 