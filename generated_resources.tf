# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_vpc" "teest" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = "10.3.0.0/16"
  enable_dns_hostnames                 = false
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  region                               = "us-east-1"
  tags                                 = {
    Name= "from another world"
  }
  tags_all                             = {}
}
