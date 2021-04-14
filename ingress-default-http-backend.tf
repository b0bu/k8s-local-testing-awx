resource "kubernetes_service" "default-http-backend" {
  metadata {
    name      = "default-http-backend"
    namespace = "ingress-nginx"
  }

  spec {
    selector = {
      app = "default-http-backend"
    }

    port {
      name        = "http"
      protocol    = "TCP"
      port        = "80"
      target_port = "8080"
    }

    port {
      name        = "https"
      protocol    = "TCP"
      port        = "443"
      target_port = "8080"
    }
  }

  depends_on = [kubernetes_namespace.ingress-nginx]
}

resource "kubernetes_deployment" "default-http-backend" {
  metadata {
    name      = "default-http-backend"
    namespace = "ingress-nginx"
  }

  spec {
    selector {
      match_labels = {
        app = "default-http-backend"
      }
    }

    replicas = "1"

    template {
      metadata {
        namespace = "ingress-nginx"

        labels = {
          app = "default-http-backend"
        }
      }

      spec {
        termination_grace_period_seconds = "60"

        container {
          name  = "default-http-backend"
          image = "gcr.io/google_containers/defaultbackend:${var.default-http-backend-version}"

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = "30"
            timeout_seconds       = "5"
          }

          port {
            container_port = "8080"
          }

          resources {
            limits {
              cpu    = "10m"
              memory = "20Mi"
            }

            requests {
              cpu    = "10m"
              memory = "20Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.ingress-nginx]
}

