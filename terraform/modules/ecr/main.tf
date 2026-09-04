resource "aws_ecr_repository" "hotstar" {
  name = "hotstar-clone"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  force_delete = true
}