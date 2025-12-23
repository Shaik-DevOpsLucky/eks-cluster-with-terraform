resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  iam_instance_profile        = var.instance_profile
  associate_public_ip_address = true

  tags = {
    Name = "eks-bastion"
  }
}