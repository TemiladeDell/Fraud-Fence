# Fraud-Fence: Real-Time Payment Anomaly Detection System

![AWS Serverless Architecture](https://img.shields.io/badge/AWS-Serverless-orange?logo=amazon-aws) 
![Terraform](https://img.shields.io/badge/Infrastructure-Terraform-purple?logo=terraform)
![Python](https://img.shields.io/badge/Code-Python-blue?logo=python)

A serverless solution for detecting suspicious payment patterns in real-time using AWS services and Terraform for infrastructure management.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Detection Logic](#detection-logic)
- [Monitoring](#monitoring)
- [Cleanup](#cleanup)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

## Architecture Overview

```mermaid
graph LR
    A[API Gateway] --> B[Lambda]
    B --> C{DynamoDB}
    B --> D{SNS}
    D --> E[Admin Email]
    B --> F[CloudWatch]
    F --> G[Alarms]

````

Component	Purpose
API Gateway	REST endpoint for payment submissions
Lambda (Python)	Core anomaly detection logic
DynamoDB	Transaction history storage
SNS	Real-time alert notifications
CloudWatch	Performance monitoring & alarms
Terraform	Infrastructure as Code provisioning
Features
✔ Real-time fraud detection with configurable rules
✔ Immediate email alerts via Amazon SNS
✔ Infrastructure as Code with Terraform
✔ Comprehensive monitoring with CloudWatch
✔ Transaction history in DynamoDB
✔ Scalable serverless architecture




Project Structure

cloudpay-watchdog/
├── .gitignore
└── terraform/
    ├── modules/
    │   ├── networking/
    │   ├── compute/
    │   └── monitoring/
    ├── alarms.tf            # CloudWatch alarm configurations
    ├── api_gateway.tf       # API Gateway setup
    ├── dynamodb.tf          # Database configuration
    ├── iam.tf               # Permission policies
    ├── lambda.tf            # Function deployment
    ├── lambda_function.py   # Detection logic
    ├── main.tf              # Core infrastructure
    ├── monitoring.tf        # Dashboards and metrics
    ├── outputs.tf           # Terraform outputs
    ├── provider.tf          # AWS provider config
    ├── sns.tf               # Notification setup
    ├── terraform.tfvars     # Variable definitions
    └── variables.tf         # Input variables



Deployment Steps
Clone the repository:


git clone https://github.com/TemiladeDell/fraud-fence.git
cd fraud-fence/terraform
Configure variables in terraform.tfvars:


lambda_function_name = "payment-anomaly-detector"
alert_email = "your-email@example.com"
threshold_amount = 10000  # Customize anomaly threshold
Initialize and deploy:


terraform init
terraform plan -out=tfplan
terraform apply tfplan
Deploy Lambda code:


zip lambda.zip lambda_function.py
aws lambda update-function-code \
  --function-name payment-anomaly-detector \
  --zip-file fileb://lambda.zip



Usage
curl -X POST \
  https://your-api-gateway-url.execute-api.region.amazonaws.com/prod/transactions \
  -H 'Content-Type: application/json' \
  -d '{
    "transaction_id": "txn_789012",
    "amount": 15000,
    "timestamp": "2025-08-07T14:30:00Z",
    "user_id": "user_456",
    "payment_method": "credit_card"
  }'


  Expected Responses
200 OK: Valid transaction processed

400 Bad Request: Missing required fields

202 Accepted: Transaction flagged for review

Detection Logic
The system checks for:

Amount Threshold: Transactions exceeding threshold_amount

Velocity Checks: >3 transactions in 5 minutes from same user

Duplicate IDs: Repeated transaction IDs

Geographical Anomalies: Unusual location patterns (future enhancement)

Monitoring
Key CloudWatch Metrics:

Invocations - Total function executions

Errors - Failed detection attempts

Throttles - Rate-limiting events

Duration - Processing time percentiles

Alarms are configured for:

Error rate >1% over 5 minutes

Function timeout frequency

SNS delivery failures



Cleanup
To remove all resources:

bash
terraform destroy
Roadmap
Machine Learning integration (AWS SageMaker)

Multi-channel alerts (SMS, Slack)

User behavior profiling

Admin dashboard

Whitelisting/blacklisting capabilities


Author: Temilade Akinyimika
[Linkedln](www.linkedin.com/in/temilade-akinyimika-dell001) | [Medium](https://medium.com/@temiladedell)
