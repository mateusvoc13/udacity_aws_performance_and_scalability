# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-west-2"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "T2" {
  ami = "ami-0a36eb8fadc976275"
  instance_type = "t2.micro"
  count = 4
  subnet_id = "subnet-7c1daf21"

  tags = {
    Name = "Udacity T2"
    Terraform   = "true"
    Udacity = "true"
    Environment = "dev"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
