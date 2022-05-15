provider "aws" {                     # AWS infrastructure
  region = var.regionname
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "docker_instance" {    #Ec2 Instance launch
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.docker_subnet.id
  security_groups = [aws_security_group.docker_security_group.id]
  key_name = "Mykey1"
  tags = {
    Name = "docker_instance"
  }

  #!/bin/bash                   # Docker installing on instance
sudo apt-get update
sudo apt-get install \
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

data "aws_vpc" "default" {    # Provided with Default VPC
  default = true
}

data "aws_subnet" "docker_subnet" {     # Subnet association
  filter {
    name   = "tag:Name"
    values = ["dockersubnet"]

  }
}

resource "aws_db_instance" "default" {     # Creating postgre database for backend storage
  allocated_storage    = 10
  engine               = "postgresql"
  engine_version       = "10.7"
  instance_class       = "db.t3.micro"
  name                 = "MyDB"
  username             = "gtdapp"
  password             = "stayconnected"
  skip_final_snapshot  = true
}

resource "aws_security_group" "docker_security_group" {     # assigning security groups
  name   = "docker_SG"
  vpc_id = data.aws_vpc.default.id

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "docker_SG"
  }
}

resource "aws_autoscaling_group" "request_auto_scale" {           #Auto scaling on workload
  launch_configuration = [aws_launch_configuration.test_launch.id]
  min_size = 1
  max_size = 5
  health_check_type = "EC2"
  desired_capacity = 2
  tag {
    key = "Auto-scale"
    value = "request_auto_scale"
    propagate_at_launch = true
  }
}


resource "aws_launch_configuration" "test_launch" {       #Auto-scaling deployment required configurations
  name            = "My_launch"
  image_id        = var.ami
  instance_type   = "t2.micro"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.docker_security_group.id]
  key_name        = "Suhas"


  lifecycle {
    create_before_destroy = true
  }
}