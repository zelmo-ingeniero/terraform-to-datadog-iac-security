
terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "3.59"

    }
  }
}


provider "datadog" {
  api_key = var.datadog_api_key
  api_url = var.datadog_api_url
  app_key = var.datadog_app_key
}

module "primer_modulo" {
  source  = "./monitors"
  nombres  = local.nombres
  mensaje = "Esto es una prueba de mensaje"
  metricas = {
    "system.cpu.user" = {
      warning  = "3"
      critical = "4"
    }

  }
  destinatarios   = ["sergio.valencia@example.com","erick@example.com","salgado@example.com","fernando@example.com"]
  datadog_api_key = var.datadog_api_key
  datadog_app_key = var.datadog_app_key
  etiquetas = [ "env:test","service:test" ]
}