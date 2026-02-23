
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

variable "metricas" {
  description = "The APP Key of the user in the respective organization"
  type        = map(map(string))
  default     = {}
  # validation {
  #   condition     = length(var.ports) > 0
  #   error_message = "At least one port is required to open"
  # }
}

variable "destinatarios" {
  description = "Usuarios que reciben el mensaje"
  type        = list(string)
  default     = []
}

variable "nombres" {
  description = "Nombre o titulo"
  type        = list(string)
  default     = []
}

variable "mensaje" {
  description = "Mensaje del monitor"
  type        = string
  default     = ""
}

variable "etiquetas" {
  description = "Etiquetas del monitor"
  type        = list(string)
  default     = []
}

