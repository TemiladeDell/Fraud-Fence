resource "aws_sns_topic" "anomaly_alerts" {
  name         = "payment-anomaly-alerts"  
  display_name = "Payment Monitoring Alerts"  
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.anomaly_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
