
variable "apps" {
  description = "CodeDeploy apps with their list of deployment groups"
  type        = map(list(string))
  default     = {}
  validation {
    condition     = length(keys(var.apps)) > 0
    error_message = "At least 1 app is required"
  }
}

variable "ec2_nametag" {
  description = "Tag name of the EC2 instance"
  type        = string
  default     = ""
  validation {
    condition     = length(var.ec2_nametag) > 0
    error_message = "One EC2 tag name is required"
  }
}

variable "role_arn" {
  description = "Service role ARN previously created"
  type        = string
  default     = ""
  validation {
    condition     = length(var.role_arn) > 0
    error_message = "One CodeDeploy service role is required"
  }
  validation {
    # condition     = can(regex("^arn:aws:iam:([a-z]{2}-[a-z]{2,6}-[0-9]{1})?:(\\d{12})?:role/[0-9A-Za-z-]*(\\*)?$", var.role_arn))
    condition     = can(regex("^arn:aws:iam::(\\d{12})?:role/[0-9A-Za-z-]*(\\*)?$", var.role_arn))
    error_message = "The ARN inserted is not valid should be an IAM role arn"
  }
}
