module "naming" {
  source   = "git@github.com:OT-CLOUD-KIT/terraform-aws-naming.git?ref=dev"
  bu       = var.bu
  env      = var.env
  app      = var.app
  tenant   = var.tenant
  resource = var.resource
}

module "standard_tags" {
  source = "git@github.com:OT-CLOUD-KIT/terraform-aws-standard-tagging.git?ref=dev"

  bu      = var.bu
  program = var.program
  app     = var.app
  team    = var.team
  region  = var.region
  env     = var.env
}

module "alb" {
  source = "../" 

  name       = "myapp-alb"
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids
  bu                                   = var.bu
  program                              = var.program
  team                                 = var.team
  app                                  = var.app
  env                                  = var.env
  create_sg      = var.create_sg
  existing_sg_id = var.existing_sg_id
  alb_certificate_arn = var.certificate_arn
  enable_https        = var.enable_https

  access_logs = {
    enabled = true
    bucket  = var.access_log_bucket
    prefix  = "myapp-alb"
  }

  internal                   = false
  enable_deletion_protection = true

  allowed_cidrs = ["0.0.0.0/0"]
  tags = {
    Environment = "dev"
    App         = "myapp"
  }

  listeners = var.listeners
  region =   var.region
}



