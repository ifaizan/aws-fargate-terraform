# resource "aws_security_group" "http_sg_terraform" {
#   name        = "Allow HTTP"
#   description = "This security group allows HTTP from all IPs"
#   vpc_id      = aws_vpc.VPC_created_by_terraform.id

#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "HTTP Rule"
#     from_port   = 80
#     protocol    = "tcp"
#     to_port     = 80
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Allow HTTP"
#   }
# }

resource "aws_lb" "lb_terraform" {
  name               = "load-balancer-fargate"
  load_balancer_type = "application"
  subnets            = [aws_subnet.main_public_1.id, aws_subnet.main_public_2.id]
  security_groups    = [aws_security_group.http_sg_terraform.id]

  tags = {
    "Name" = "Fargate Production"
  }
}

resource "aws_lb_target_group" "fargate_target_group" {
  name        = "fargate-target-group"
  target_type = "ip"
  vpc_id      = aws_vpc.VPC_created_by_terraform.id
  port        = 80
  protocol    = "HTTP"

  health_check {
    enabled  = true
    path     = "/health"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "lb_fargate_listener" {
  load_balancer_arn = aws_lb.lb_terraform.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate_target_group.arn
  }
}

# resource "aws_lb_target_group_attachment" "target_group_attachment_terraform" {
#   target_group_arn = aws_lb_target_group.fargate_target_group.arn
#   target_id        = aws_lb_target_group.fargate_target_group.id
# }

output "load_balancer_dns" {
  value = aws_lb.lb_terraform.dns_name
}