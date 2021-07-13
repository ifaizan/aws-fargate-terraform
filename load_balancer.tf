resource "aws_security_group" "sg_terraform" {
  name        = "Allow HTTP"
  description = "This security group allows HTTP from all IPs"
  vpc_id      = aws_vpc.VPC_created_by_terraform.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Rule"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP"
  }
}

resource "aws_lb" "lb_terraform" {
  name = "load-balancer-fargate"
  load_balancer_type = "application"
  subnets = [aws_subnet.main_public_1.id, aws_subnet.main_public_2.id]
  security_groups = [aws_security_group.sg_terraform.id]
  tags = {
    "Name" = "Fargate Production"
  }
}