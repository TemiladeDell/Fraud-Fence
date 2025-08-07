resource "aws_kinesis_stream" "payment_stream" {
  name             = var.stream_name
  shard_count      = var.shard_count
  retention_period = var.retention_period
  encryption_type  = "KMS"    
  kms_key_id       = "alias/aws/kinesis" 
  tags             = var.tags
}
