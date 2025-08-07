resource "aws_dynamodb_table" "payment_logs" {
  name         = "PaymentLogs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "payment_id"
  
  attribute {
    name = "payment_id"
    type = "S"
  }

  tags = {
    Environment = "production"
  }
}	
