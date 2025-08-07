variable "stream_name" {
  description = "Name of the Kinesis stream"
  type        = string
  default     = "payment_transactions"
}

variable "shard_count" {
  description = "Number of shards for the Kinesis stream"
  type        = number
  default     = 1
}

variable "retention_period" {
  description = "How long data records are accessible in the stream (in hours)"
  type        = number
  default     = 24
}

variable "tags" {
  description = "Tags to apply to the Kinesis stream"
  type        = map(string)
  default     = {
    Name        = "PaymentStream"
    Environment = "Dev"
  }
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "alert_email" {
  description = "Email address for SNS alerts"
  type        = string
}
