resource "aws_security_group" "sg_terraform" {
  name        = "Allow SSH"
  description = "This security group allows ssh from all IPs"
  vpc_id      = aws_vpc.VPC_created_by_terraform.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Rule"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  tags = {
    Name = "Allow SSH"
  }
}