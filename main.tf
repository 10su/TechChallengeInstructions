provider "aws" {# This is the AWS provider created to deploy the cloud infrastructure, for the requirement we can lock the terraform version to a required version
  region = var.regionname
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "docker_instance" { # This is the EC2 instance that has been created to deploy the docker containers
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.docker_subnet.id
  security_groups = [aws_security_group.docker_security_group.id]
  key_name = "Mykey1"
  tags = {
    Name = "docker_instance"
  }

  user_data = <<-EOF
    #!/bin/bash
  sudo apt-get update
  sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
EOF
}

data "aws_vpc" "default" { # Data Source block could be used to fetch the default vpc details, or this could be used to fetch information about vpc from cloud
  default = true
}

data "aws_subnet" "docker_subnet" { # Data Source block could be used to fetch the subnet details, if there is decision to not create a new subnet and to make use of existing cloud infrastructure
  filter {
    name   = "tag:Name"
    values = ["dockersubnet"]

  }
}
output "subnetid" { #Output block has been used to fetch and verify the subnet id details to pass this as an argument for resource creations
  value = data.aws_subnet.docker_subnet.id
}

resource "aws_security_group" "docker_security_group" { #Security group is getting created as this would be associated for an ec2 instance and port 22 is opened
  name        = "docker_SG"
  vpc_id      = data.aws_vpc.default.id

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "docker_SG"
  }
}
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "14.2"
  instance_class       = "db.t3.micro"
  name                 = "serviandb"
  username             = "postgres"
  password             = "changeme"
  skip_final_snapshot  = true
}
resource "aws_security_group" "db_security_group" {
  name        = "db_SG"
  vpc_id      = data.aws_vpc.default.id

  ingress {

    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "db_sg"
  }
}
