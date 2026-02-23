
variable "bucket_name" {
  description = "The \"artifact store\" bucket name"
  type        = string
  default     = ""
  validation {
    condition     = length(regexall("[!-,:-@[-`{-~/]+", var.bucket_name)) == 0
    error_message = "Some bucket name has special symbols"
  }
  validation {
    condition     = length(regexall("[A-Z]+", var.bucket_name)) == 0
    error_message = "Some bucket name has uppercases"
  }
  validation {
    condition     = length(var.bucket_name) < 64 && length(var.bucket_name) > 2
    error_message = "Some bucket name is too short or large"
  }
}
