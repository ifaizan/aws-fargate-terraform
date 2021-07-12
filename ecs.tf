resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "my-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "my_cluster_task_definition" {
  family = "my_cluster_task_definition"
  //container_definitions    = templatefile("./task-definition.json", { image_id = "${aws_ecr_repository.my_repo_tf.repository_url}" })
  container_definitions = jsonencode([
    {
      name  = "HelloFromFargate"
      image = "${aws_ecr_repository.my_repo_tf.repository_url}"
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