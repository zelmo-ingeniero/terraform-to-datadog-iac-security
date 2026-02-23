/*
output "user_names" {
  description = "Names of the users"
  value       = data.datadog_users.this.users[*].email
  //value       = data.datadog_users.this
}
output "logs" {
  description = "log indexes"
  value = {
    name           = data.datadog_logs_indexes.this.logs_indexes[*].name
    retention_days = data.datadog_logs_indexes.this.logs_indexes[*].retention_days
  }
}

output "monitors" {
  description = "Names of the monitors"
  value       = length(data.datadog_monitors.this.monitors)
}

output "mapa" {
  description = "Names of the monitors"
  value       = local.users
}*/

output "this" {
  description = "contenido de monitor"
  value       = keys(var.metricas)[0]

}
output "metricas" {
  description = "contenido metricas"
  value       = var.metricas
}
