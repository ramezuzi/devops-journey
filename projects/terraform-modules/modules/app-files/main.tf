resource "local_file" "config" {
  filename = "${path.module}/../../output/${var.app_name}.conf"
  content  = "APP=${var.app_name}\nENV=${var.environment}"
}
