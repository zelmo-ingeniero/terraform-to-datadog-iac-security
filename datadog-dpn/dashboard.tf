
locals {
  nombres = ["nombre1", "nombre2", "nombre3", "nombre4", "nombre5", "nombre6", "nombre7", "nombre8"]
  users = { for u in data.datadog_users.this.users : u.email => {
    fecha         = u.created_at
    correo        = u.email
    nombreUsuario = u.name
  } }
}
/*
# Example Ordered Layout
resource "datadog_dashboard" "this" {
  for_each    = local.users
  title       = "Ordered Layout Dashboard ${each.key}"
  description = "Created using the Datadog provider in Terraform ${each.value.nombreUsuario}"
  layout_type = "ordered"

  widget {
    change_definition {
      request {
        q             = "avg:system.load.1{*} by {account}"
        change_type   = "absolute"
        compare_to    = "week_before"
        increase_good = true
        order_by      = "name"
        order_dir     = "desc"
        show_present  = true
      }
      title     = "Widget Title ${each.key}"
      live_span = "1h"
    }
  }

  widget {
    distribution_definition {
      request {
        q = "avg:system.load.1{*} by {account}"
        style {
          palette = "warm"
        }
      }
      title     = "Widget Title ${each.key}"
      live_span = "1h"
    }
  }
}
*/