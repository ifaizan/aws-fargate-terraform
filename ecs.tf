resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "my-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "aws_ecs_task_definition" {
  family = "my_cluster_task_definition"
  //container_definitions    = templatefile("./task-definition.json", { image_id = "${aws_ecr_repository.my_repo_tf.repository_url}" })
  container_definitions = jsonencode([
    {
      name  = "HelloFromFargate"
      image = "${aws_ecr_repository.my_repo_tf.repository_url}:latest"
      # cpu       = 1
      # memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
}

resource "aws_ecs_service" "ecs_service_fargate" {
  name            = "ecs_service_fargate"
  cluster         = aws_ecs_cluster.my_ecs_cluster.id
  task_definition = aws_ecs_task_definition.aws_ecs_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["${aws_subnet.main_private_1.id}", "${aws_subnet.main_private_2.id}"]
    security_groups = ["${aws_security_group.http_sg_terraform.id}"]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fargate_target_group.arn
    container_name   = "HelloFromFargate"
    container_port   = "3000"
  }
}