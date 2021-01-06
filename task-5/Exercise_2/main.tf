# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-west-2"
}

module "vpc" {
  source = "../../"

  name = "udacity-simple-vpc"
  cidr = "10.0.0.0/16"
  azs             = ["us-west-2"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-name"
  }
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:Describe*",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "greet_lambda.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "exports.test"

  runtime = "python3.8"

  vpc_config {
    subnet_ids = ["subnet-7c1daf21"]
    security_group_ids = ["sg-6fd86d4c"]
  }

  environment {
    variables = {
      foo = "bar"
    }
  }
}
