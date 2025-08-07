resource "aws_cloudwatch_metric_alarm" "high_error_rate" {
  alarm_name          = "LambdaHighErrorRate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  threshold           = 5
  statistic           = "Sum"
  alarm_description   = "Triggers if Lambda errors exceed 5 in 5 minutes"
  alarm_actions       = [aws_sns_topic.anomaly_alerts.arn]
  dimensions = {
    FunctionName = aws_lambda_function.anomaly_detector.function_name
  }
}
