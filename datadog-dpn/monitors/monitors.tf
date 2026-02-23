
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

resource "datadog_monitor" "foo" {
  for_each = toset(var.nombres)
  name               = "Name for monitor foo ${each.key}"
  type               = "metric alert"
  message            = "${var.mensaje}\n@${join("\n @", var.destinatarios)}"
  escalation_message = "Escalation message @pagerduty"

  query = "avg(last_1h):${keys(var.metricas)[0]}{*} by {host} > 4"


  monitor_thresholds {
    warning  = values(var.metricas)[0].warning
    critical = values(var.metricas)[0].critical
  }

  include_tags = true

  tags = var.etiquetas
}