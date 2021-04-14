resource "kubernetes_limit_range" "namespace-limits" {
  metadata {
    name      = "default"
    namespace = "default"
  }

  spec {
    limit {
      type = "Container"

      default = {
        cpu    = "500m"
        memory = "512Mi"
      }

      default_request = {
        cpu    = "50m"
        memory = "256Mi"
      }
    }
  }
}