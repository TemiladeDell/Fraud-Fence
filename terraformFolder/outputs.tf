output "kinesis_stream_name" {
  description = "The name of the Kinesis stream"
  value       = aws_kinesis_stream.payment_stream.name
}

output "kinesis_stream_arn" {
  description = "The ARN of the Kinesis stream"
  value       = aws_kinesis_stream.payment_stream.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.anomaly_detector.function_name
}

output "api_gateway_url" {
  description = "Endpoint URL for API Gateway"
  value       = "${aws_apigatewayv2_stage.default_stage.invoke_url}/payment"
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.anomaly_alerts.arn
}
