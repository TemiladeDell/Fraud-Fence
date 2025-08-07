import json
import os
import base64
import boto3
from datetime import datetime
import uuid
import logging

# Initialize clients
sns = boto3.client('sns')
dynamodb = boto3.resource('dynamodb')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        logger.info("Received event: " + json.dumps(event))

        # --- Input Validation ---
        if not event.get('Records'):
            raise ValueError("No Kinesis records found")

        record = event['Records'][0]
        if not record.get('kinesis'):
            raise ValueError("Invalid Kinesis record format")

        # Decode data
        try:
            data = json.loads(base64.b64decode(record['kinesis']['data']).decode('utf-8'))
            payment = data.get('payment', {})
        except Exception as e:
            raise ValueError(f"Data decoding failed: {str(e)}")

        # Validate required fields
        required_fields = ['amount', 'customer_id', 'method']
        missing_fields = [field for field in required_fields if field not in payment]
        if missing_fields:
            raise ValueError(f"Missing fields: {missing_fields}")

        amount = float(payment['amount'])
        if amount <= 0:
            raise ValueError("Amount must be positive")

        # --- Anomaly Detection ---
        threshold = float(os.environ['THRESHOLD_AMOUNT'])
        if amount > threshold:
            # Human-readable alert message
            alert_msg = f"""
🚨 HIGH-VALUE PAYMENT ALERT 🚨

Amount: ${amount:,.2f}
Customer: {payment.get('customer_id', 'Unknown')}
Location: {payment.get('location', 'Not specified')}
Payment Method: {payment.get('method', 'Unknown')}
Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

THRESHOLD EXCEEDED BY: ${amount - threshold:,.2f}
(Threshold: ${threshold:,.2f})

Please review this transaction immediately.
"""

            # Send formatted SNS alert
            sns.publish(
                TopicArn=os.environ['SNS_TOPIC_ARN'],
                Message=alert_msg,
                Subject=f"URGENT: ${amount:,.2f} Payment Requires Review"
            )

            # Log to DynamoDB
            dynamodb.Table(os.environ['DYNAMODB_TABLE']).put_item(Item={
                "payment_id": str(uuid.uuid4()),
                "amount": amount,
                "customer_id": payment['customer_id'],
                "location": payment.get('location'),
                "method": payment.get('method'),
                "is_anomaly": True,
                "threshold": threshold,
                "processed_at": datetime.now().isoformat(),
                "alert_sent": True
            })

            return {"status": "ALERT_SENT"}

        # Log normal payments
        dynamodb.Table(os.environ['DYNAMODB_TABLE']).put_item(Item={
            "payment_id": str(uuid.uuid4()),
            **payment,
            "is_anomaly": False,
            "processed_at": datetime.now().isoformat()
        })

        return {"status": "NORMAL_PAYMENT"}

    except Exception as e:
        logger.error(f"CRITICAL ERROR: {str(e)}")
        # Send error alert
        sns.publish(
            TopicArn=os.environ['SNS_TOPIC_ARN'],
            Message=f"Payment processing failed:\n\n{str(e)}\n\nRaw event:\n{json.dumps(event)}",
            Subject="PAYMENT PROCESSING ERROR"
        )
        raise e
