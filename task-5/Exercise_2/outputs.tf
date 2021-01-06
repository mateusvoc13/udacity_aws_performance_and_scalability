# TODO: Define the output variable for the lambda function.
output "function_invoke_arn" {
  description = "The Invoke ARN of the Lambda function"
  value       = aws_lambda_function.greet_lambda.invoke_arn
}
