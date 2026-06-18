resource "aws_ecr_repository" "backend" {
  name                 = "${var.project}-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags                 = { Name = "${var.project}-backend" }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "${var.project}-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags                 = { Name = "${var.project}-frontend" }
}
