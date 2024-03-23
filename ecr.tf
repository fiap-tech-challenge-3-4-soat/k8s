resource "aws_ecr_repository" "sistema-pedidos_ecr" {
  name = "${var.project_name}"
  image_tag_mutability = "MUTABLE" # Change if needed

  image_scanning_configuration {
      scan_on_push = false # Change if needed
  }
}