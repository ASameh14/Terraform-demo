resource "aws_vpc" "Mamdouh-prim" {
  cidr_block           = "10.2.0.0/16"
  tags = {
    Name = "Mamdouh-VPC"
  }
}