data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

resource "aws_iam_instance_profile" "lab" {
  name = "${var.project}-instance-profile"
  role = data.aws_iam_role.lab_role.name
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.lab.name
  associate_public_ip_address = true
  tags                        = { Name = "${var.project}-bastion" }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
  tags     = { Name = "${var.project}-bastion-eip" }
}

resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.backend_sg_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.lab.name
  tags                   = { Name = "${var.project}-backend" }
}

resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_ids[1]
  vpc_security_group_ids = [var.frontend_sg_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.lab.name
  tags                   = { Name = "${var.project}-frontend" }
}
