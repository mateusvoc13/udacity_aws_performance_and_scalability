# TODO: Define the output variable for the lambda function.
output "api_gateway" {
  value = "${aws_lambda_function.test_lambda.filename}"
}