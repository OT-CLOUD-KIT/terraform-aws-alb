region =  "us-east-1"

vpc_id = "vpc-0bfa15004ff55e107"

public_subnet_ids = [
  "subnet-08a2aa30dbc179a2b",
  "subnet-0a49bf4221b5f0107"
]

create_sg      = false
existing_sg_id = "sg-04fb2f273d8865af3"

certificate_arn = ""  # Use empty string, not []

enable_https = false

access_log_bucket = ""

listeners = [
  {
    port            = 80
    protocol        = "HTTP"
    target_port     = 80
    target_protocol = "HTTP"
    health_path     = "/"
  }
]

################## Naming Convension #####################

random_alphanumeric_len = 4

bu       = "ot"
app      = "bp"
env      = "d"
resource = "ALB"
tenant   = ""

special = false
upper   = false
number  = true

gen_no_of_names = 1

team    = "devops"
program = "ot"