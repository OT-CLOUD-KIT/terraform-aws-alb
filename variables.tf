
variable "alb_name" {
  description = "Name of ALB"
  type = string
}

variable "internal" {
  type = boolean
}

variable "security_groups_id" {
    description = "Security groups to be associated with ALB"
    type = list(string)
}

variable "subnets_id" {
  description = "Subnets to be mapped with ALB"
  type =list(string)
}

variable "enable_deletion_protection " {
  default = true
  type = boolean
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "logs_bucket" {
  description = "Name of bucket where we would be storing our logs"
}

variable "enable_logging" {
  default = true
}

