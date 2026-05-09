terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# random string resource
resource "random_string" "app_id" {
  length  = 8
  special = false
  upper   = false
}

# create local files
resource "local_file" "app_config" {
  filename = "${path.module}/output/app.conf"
  content  = <<-EOT
    APP_ID=${random_string.app_id.result}
    ENV=${var.environment}
    VERSION=${var.app_version}
    CREATED_AT=${timestamp()}
  EOT
}

resource "local_file" "readme" {
  filename = "${path.module}/output/README.md"
  content  = "# App ${random_string.app_id.result}\nEnvironment: ${var.environment}"
}
