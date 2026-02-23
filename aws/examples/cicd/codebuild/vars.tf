
variable "node_repos" {
  description = "Map of node repositories with their environments list"
  type        = map(list(string))
  default     = {}
}

variable "java_repos" {
  description = "Map of java repositories with their environments list"
  type        = map(list(string))
  default     = {}
}

variable "artifact_bucket" {
  description = "The bucket where already exists the .zip files from the repositories"
  type        = string
  default     = ""
  validation {
    condition     = length(regexall("[!-,:-@[-`{-~/]+", var.artifact_bucket)) == 0
    error_message = "The bucket name has special symbols"
  }
  validation {
    condition     = length(regexall("[A-Z]+", var.artifact_bucket)) == 0
    error_message = "The bucket name has uppercases"
  }
  validation {
    condition     = length(var.artifact_bucket) < 64 && length(var.artifact_bucket) > 2 || length(var.artifact_bucket) == 0
    error_message = "The bucket name is too short or large"
  }
}
