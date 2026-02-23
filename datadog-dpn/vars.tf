
variable "datadog_api_key" {
  description = "The organization API KEY"
  type        = string
  default     = ""
  # validation {
  #   condition     = length(var.ports) > 0
  #   error_message = "At least one port is required to open"
  # }
}

variable "datadog_api_url" {
  description = "The datadog site (datadoghq.com for example)"
  type        = string
  default     = "https://api.datadoghq.com"
  # validation {
  #   condition     = length(var.ports) > 0
  #   error_message = "At least one port is required to open"
  # }
}

variable "datadog_app_key" {
  description = "The APP Key of the user in the respective organization"
  type        = string
  default     = ""
  # validation {
  #   condition     = length(var.ports) > 0
  #   error_message = "At least one port is required to open"
  # }
}