provider "aws" {
  region = "us-east-1"
}

variable "environment" {
  description = "The environment for development"
  type        = string
  default     = "dev"
}
locals {
  name   = "saige-developer"
  ami = "ami-0f93c02efd1974b8b"
  instance_type = "r7gd.2xlarge"
  keyname = "saige-developer"
  private_subnet = "subnet-0fb2dbd310c5099f8"
  # security_group = "sg-0b5701b4e00fc3b59"
}
data "aws_security_group" "saige_vpc_sg" {
  name        = "saige-vpc-sg"
}

data "aws_subnets" "saige_vpc_subnet" {
  filter {
    name = "tag:Name"
    values = ["Private Subnet 1"]
  }
}

resource "aws_iam_role" "saige_ssm_role" {
  name = "saige-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_network_interface" "developer-network-interface" { 
  subnet_id = data.aws_subnets.saige_vpc_subnet.ids[0]
  security_groups = [data.aws_security_group.saige_vpc_sg.name]
}

  
  resource "aws_iam_instance_profile" "ssm_instance_profile" {
    name = "ssm-instance-profile"
    role = aws_iam_role.saige_ssm_role.name
  }

data "aws_ebs_volume" "Caves_of_Steel" {
  most_recent = true
  filter {
    name = "tag:Name"
    values = ["Caves of Steel"]
  }
}

output "Caves_of_Steel" {
  value = data.aws_ebs_volume.Caves_of_Steel.id
}

resource "aws_volume_attachment" "developer-prod" {
  device_name = "/dev/sdf"
  volume_id   = data.aws_ebs_volume.Caves_of_Steel.id
  instance_id =  aws_instance.developer-instance[0].id
  count = var.environment == "prod" ? 1:0
}

resource "aws_volume_attachment" "developer-spot" {
  device_name = "/dev/sdf"
  volume_id   = data.aws_ebs_volume.Caves_of_Steel.id
  instance_id = aws_spot_instance_request.developer-spot[0].spot_instance_id

  depends_on = [
    aws_spot_instance_request.developer-spot
  ]
}

resource "aws_launch_template" "developer-template" {
  name = "developer-template"
  image_id = local.ami
  instance_type = local.instance_type
  key_name = local.keyname
  # user_data = base64encode(templatefile("${path.module}/init_script.tpl", {}))
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }
  network_interfaces {
    device_index = 0
    network_interface_id = aws_network_interface.developer-network-interface.id    
  } 

    tags = {
    Name = "Developer"
  }
}

resource "aws_instance" "developer-instance" {
  ami = local.ami
  count = var.environment == "prod" ? 1:0

  launch_template {
    id = aws_launch_template.developer-template.id
    version = "$Latest"
  }
}

resource "aws_spot_instance_request" "developer-spot" {
  spot_price = "0.24"
  ami = local.ami
  instance_type = local.instance_type
  key_name = local.keyname
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  subnet_id = "subnet-0fb2dbd310c5099f8"
  security_groups = [data.aws_security_group.saige_vpc_sg.name]
  count = var.environment == "prod" ? 0:1
  wait_for_fulfillment = true
}

resource "aws_ec2_tag" "developer-spot-tag" {
  resource_id = aws_spot_instance_request.developer-spot[0].spot_instance_id
  key = "Name"
  value = "Waldo and Magic, Inc"
}

