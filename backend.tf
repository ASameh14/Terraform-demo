terraform {
  backend "s3" {
    bucket         = "sameh-amr-mamdouh-project"
    key            = "day1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}