module "api_app" {
  source      = "./modules/app-files"
  app_name    = "api"
  environment = "production"
}

module "worker_app" {
  source      = "./modules/app-files"
  app_name    = "worker"
  environment = "production"
}

output "api_config" {
  value = module.api_app.filename
}

output "worker_config" {
  value = module.worker_app.filename
}
