
variable "public_subnets" {
  description = "Subnets public specifications"
  type        = map(string)
  default     = {}
  validation {
    condition = alltrue([
      for s in keys(var.public_subnets) :
      can(regex("^([0-9]{1,3}.){3}([0-9]{1,3})/([0-9]{1,2})", s))
    ])
    error_message = "The public_subnets has invalid CIDRs"
  }
}

variable "private_subnets" {
  description = "Subnets private specifications"
  type        = map(string)
  default     = {}
  validation {
    condition = alltrue([
      for s in keys(var.private_subnets) :
      can(regex("^([0-9]{1,3}.){3}([0-9]{1,3})/([0-9]{1,2})$", s))
    ])
    error_message = "The private_subnets has invalid CIDRs"
  }
}

variable "cidr" {
  description = "The lower CIDR"
  type        = string
  default     = ""
  validation {
    condition     = can(regex("^([0-9]{1,3}.){3}[0-9]{1,3}(/([0-9]{1,2}))$", var.cidr))
    error_message = "The CIDR to the VPC is invalid"
  }
}

variable "tag_name" {
  description = "Text to the end of the resource names"
  type        = string
  default     = ""
  validation {
    condition     = can(regex("^(-[0-9A-Za-z-]*)?$", var.tag_name))
    error_message = "Suffix should start with a \"-\", have no spaces and no symbols"
  }
}
