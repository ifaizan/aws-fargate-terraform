resource "aws_ecr_repository" "my_repo_tf" {
  name                 = "mydockerrepo"
  image_tag_mutability = "MUTABLE"
}

output "repository_URL" {
  value = aws_ecr_repository.my_repo_tf.repository_url
}