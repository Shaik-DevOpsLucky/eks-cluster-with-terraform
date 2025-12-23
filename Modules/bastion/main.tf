resource "aws_instance" "bastion" {
  ami                  = "ami-0ecb62995f68bb549"
  instance_type        = "t3.small"
  subnet_id            = var.public_subnet_ids[0]
  iam_instance_profile = var.instance_profile

  tags = {
    Name = "bastion-host"
  }
}