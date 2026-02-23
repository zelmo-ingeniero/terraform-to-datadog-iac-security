

variable "name" {
  description = "The tag name that will be in all module resources"
  type        = string
  default     = ""
  validation {
    condition     = var.name != ""
    error_message = "The name to the ALB are required"
  }
}

variable "suffix" {
  description = "The suffix that will be at the end of each tag name, is recommended that starts with -"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "ID of some VPC"
  type        = string
  default     = ""
  validation {
    condition     = startswith(var.vpc_id, "vpc-")
    error_message = "The introduced ID is invalid"
  }
}

variable "sgp_ids" {
  description = "ID of one existing Security Group that belongs to the var.vpc_id"
  type        = list(string)
  default     = []
  validation {
    condition = alltrue([for id in var.sgp_ids :
      startswith(id, "sgp-")
    ])
    error_message = "Some of the introduced IDs are invalid"
  }
}

variable "ports" {
  description = "List of ports that will have open the security group"
  type        = list(number)
  default     = []
  # validation {
  #   condition     = length(var.ports) > 0
  #   error_message = "At least one port is required to open"
  # }
}

# variable "domain" {
#   description = "The FQDN to the certified load balancer"
#   type        = string
#   default     = ""
# }

# variable "certificate_arn" {
#   description = "ARN of the certificate to the Load balancer"
#   type        = string
#   default     = ""
# }

variable "cidr_zero" {
  description = "Exactly 0.0.0.0/0"
  type        = string
  default     = "0.0.0.0/0"
}
