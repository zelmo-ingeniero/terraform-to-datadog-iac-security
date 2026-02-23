
variable "buckets" {
  description = "Visible bucket names with their versioning"
  type        = map(list(string))
  default     = {}
  validation {
    condition = alltrue([
      for n in keys(var.buckets) : length(regexall("[!-,:-@[-`{-~/]+", n)) == 0
    ])
    error_message = "Some bucket name has special symbols"
  }
  validation {
    condition = alltrue([
      for n in keys(var.buckets) : length(regexall("[A-Z]+", n)) == 0
    ])
    error_message = "Some bucket name has uppercases"
  }
  validation {
    condition = alltrue([
      for n in keys(var.buckets) : length(n) < 64 && length(n) > 2
    ])
    error_message = "Some bucket name is too short or large"
  }
}

variable "logging" {
  description = "The bucket that will receive cloudtrail logs from each bucket in: var.buckets"
  type        = string
  default     = ""
  validation {
    condition     = length(regexall("[!-,:-@[-`{-~/]+", var.logging)) == 0
    error_message = "The bucket name has special symbols"
  }
  validation {
    condition     = length(regexall("[A-Z]+", var.logging)) == 0
    error_message = "The bucket name has uppercases"
  }
  validation {
    condition     = length(var.logging) < 64 && length(var.logging) > 2 || length(var.logging) == 0
    error_message = "The bucket name is too short or large"
  }
}
