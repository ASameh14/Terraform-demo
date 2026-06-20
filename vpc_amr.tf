resource "aws_vpc" "TestingLock" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Amr-VPC"
    Role = "Testingllock"
  }
}