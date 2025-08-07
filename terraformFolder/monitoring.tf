resource "aws_cloudwatch_dashboard" "anomaly_dashboard" {
  dashboard_name = "PaymentAnomalyMonitoring"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.anomaly_detector.function_name],
            ["AWS/Lambda", "Errors", "FunctionName", aws_lambda_function.anomaly_detector.function_name, {"color": "#d13212"}]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "Lambda Invocations/Errors"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 6
        width  = 24
        height = 6
        properties = {
          query = "SOURCE '/aws/lambda/${aws_lambda_function.anomaly_detector.function_name}' | filter @message like /ALERT/"
          region = "us-east-1"
          view  = "table"
          title = "Anomaly Alerts"
        }
      }
    ]
  })
}
