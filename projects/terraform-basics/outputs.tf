output "app_id" {
  value       = random_string.app_id.result
  description = "Generated application ID"
}

output "config_file_path" {
  value = local_file.app_config.filename
}
