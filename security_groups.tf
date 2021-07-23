resource "aws_security_group" "http_sg_terraform" {
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
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP"
  }
}

resource "aws_security_group" "sg_ecs_service_terraform" {
  name        = "Allow Traffic from load balancer"
  description = "This security group allows all traffic from Load balancer only"
  vpc_id      = aws_vpc.VPC_created_by_terraform.id

  ingress {
    description     = "Allow all traffic"
    from_port       = 0
    protocol        = "tcp"
    to_port         = 65535
    security_groups = ["${aws_security_group.http_sg_terraform.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow All traffic"
  }
}