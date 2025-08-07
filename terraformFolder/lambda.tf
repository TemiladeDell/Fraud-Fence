resource "aws_lambda_function" "anomaly_detector" {
  function_name = var.lambda_function_name
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 10
  memory_size   = 128

  filename         = "${path.module}/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  environment {
    variables = {
      ENVIRONMENT       = "production"
      SNS_TOPIC_ARN     = aws_sns_topic.anomaly_alerts.arn
      THRESHOLD_AMOUNT  = "10000"
      DYNAMODB_TABLE    = aws_dynamodb_table.payment_logs.name
    }
  }


  vpc_config {
    subnet_ids         = module.vpc.private_subnets  # Uses private subnets
    security_group_ids = [aws_security_group.lambda.id]
  }

  tags = var.tags
}


resource "aws_security_group" "lambda" {
  name_prefix = "lambda-sg-"
  vpc_id      = module.vpc.vpc_id

 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg"
  }
}


resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  event_source_arn  = aws_kinesis_stream.payment_stream.arn
  function_name     = aws_lambda_function.anomaly_detector.arn
  starting_position = "LATEST"
  batch_size        = 100
}
