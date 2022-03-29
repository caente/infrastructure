name                = "dimeder-1"
environment         = "test"
availability_zones  = ["us-east-1a", "us-east-1b"]
private_subnets     = ["10.0.0.0/20", "10.0.32.0/20"]
public_subnets      = ["10.0.16.0/20", "10.0.48.0/20"]
tsl_certificate_arn = "mycertificatearn"
container_memory    = 512
region = "us-east-1"
aws-region = "us-east-1"
profile = "default"