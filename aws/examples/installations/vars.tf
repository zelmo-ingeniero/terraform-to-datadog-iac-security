
variable "subnet" {
  description = "ID of the subnet of the VPC where will be the instance"
  type        = string
  default     = ""
  validation {
    condition     = can(regex("^subnet-[0-9a-z]*", var.subnet))
    error_message = "The subnet id provided is not valid"
  }
  validation {
    condition     = var.subnet != ""
    error_message = "The subnet ID to the instance is required"
  }
}

variable "type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ports" {
  description = "List of ports that will have open the security group"
  type        = list(number)
  default     = []
  validation {
    condition     = length(var.ports) > 0
    error_message = "At least one port is required to open"
  }
}

variable "scripts" {
  description = "List of names of the shellcripts that will run in the instance to install software"
  type        = list(string)
  default     = ["node.sh"]
  validation {
    condition = alltrue([for n in var.scripts :
      endswith(n, ".sh")
    ])
    error_message = "The script names ends with \".sh\""
  }
  validation {
    condition     = length(var.scripts) > 0
    error_message = "At least one script name is required"
  }
}

variable "os" {
  description = "Name of the AMI operative system"
  type        = string
  default     = "AL_2023"
  validation {
    condition     = var.os == "AL_2023" || var.os == "AL2"
    error_message = "At least one port is required to open"
  }
}

variable "key_pair" {
  description = "Name of the existent KMS key pair that will have the instance"
  type        = string
  default     = ""
  validation {
    condition     = var.key_pair != ""
    error_message = "The key_name to the instance is required"
  }
}

variable "status" {
  description = "State of the instance (stopped or running)"
  type        = string
  default     = "running"
  validation {
    condition     = var.status == "stopped" || var.status == "running"
    error_message = "Only is accepted \"stopped\" or \"running\""
  }
}

variable "volume_type" {
  description = "Type of EBS volume to the instance"
  type        = string
  default     = "gp2"
  validation {
    condition     = var.volume_type != ""
    error_message = "The subnet ID to the instance is required"
  }
}

variable "volume_size" {
  description = "Size of EBS volume to the instance in GiB"
  type        = number
  default     = 8
}

variable "include_eip" {
  description = "If the instance is in private subnet write true to create an Elastic IP"
  type        = bool
  default     = false
}

variable "name" {
  description = "Will appear in all tag names in the module"
  type        = string
  default     = ""
  validation {
    condition     = var.name != ""
    error_message = "The name to the instance is required"
  }
}
