variable "environment" {
  type        = string
  default     = "development"
  description = "Deployment environment"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

variable "app_version" {
  type        = string
  default     = "1.0.0"
  description = "Application version"
}
