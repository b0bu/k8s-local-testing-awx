# ingress spec at line 364 has been changed for local use
resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "kubernetes_service_account" "ingress-nginx" {
  metadata {
    name      = "nginx-ingress-serviceaccount"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  depends_on = [kubernetes_namespace.ingress-nginx]
}

resource "kubernetes_cluster_role" "ingress-nginx" {
  metadata {
    name = "nginx-ingress-clusterrole"

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "nodes", "pods", "secrets"]
    verbs      = ["list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get"]
  }

  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }
}

resource "kubernetes_role" "ingress-nginx" {
  metadata {
    name      = "nginx-ingress-role"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "pods", "secrets", "namespaces"]
    verbs      = ["get"]
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["ingress-controller-leader-nginx"]
    verbs          = ["get", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create"]
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    verbs      = ["get"]
  }

  depends_on = [kubernetes_namespace.ingress-nginx]
}

resource "kubernetes_role_binding" "ingress-nginx" {
  metadata {
    name      = "nginx-ingress-role-nisa-binding"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "nginx-ingress-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "nginx-ingress-serviceaccount"
    namespace = "ingress-nginx"
  }

  depends_on = [kubernetes_namespace.ingress-nginx]
}

resource "kubernetes_cluster_role_binding" "ingress-nginx" {
  metadata {
    name = "nginx-ingress-clusterrole-nisa-binding"

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "nginx-ingress-clusterrole"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "nginx-ingress-serviceaccount"
    namespace = "ingress-nginx"
  }
}

resource "kubernetes_daemonset" "ingress-nginx" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name"    = "ingress-nginx"
        "app.kubernetes.io/part-of" = "ingress-nginx"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"    = "ingress-nginx"
          "app.kubernetes.io/part-of" = "ingress-nginx"
        }

        annotations = {
          "prometheus.io/port"   = "10254"
          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        service_account_name            = "nginx-ingress-serviceaccount"
        automount_service_account_token = true

        container {
          name  = "nginx-ingress-controller"
          image = "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:${var.ingress-nginx-version}"

          resources {
            requests {
              cpu    = "50m"
              memory = "150Mi"
            }
          }

          args = ["/nginx-ingress-controller",
            "--configmap=$(POD_NAMESPACE)/nginx-configuration",
            "--publish-service=$(POD_NAMESPACE)/ingress-nginx",
            "--annotations-prefix=nginx.ingress.kubernetes.io",
            "--default-backend-service=$(POD_NAMESPACE)/default-http-backend",
            "--default-ssl-certificate=ingress-nginx/ingress-https"]

          security_context {
            capabilities {
              drop = ["ALL"]
              add  = ["NET_BIND_SERVICE"]
            }

            # www-data -> 101
            run_as_user = "101"
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          port {
            name           = "http"
            container_port = "80"
          }

          port {
            name           = "https"
            container_port = "443"
          }

          liveness_probe {
            failure_threshold = "3"

            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = "10"
            period_seconds        = "10"
            success_threshold     = "1"
            timeout_seconds       = "1"
          }

          readiness_probe {
            failure_threshold = "3"

            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            period_seconds    = "10"
            success_threshold = "1"
            timeout_seconds   = "1"
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.ingress-nginx]
}

resource "kubernetes_secret" "ingress-nginx" {
  metadata {
    name      = "ingress-dhparams"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  data = {
    "dhparam.pem" = <<EOF
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA1CE5WycI8Gk6/2bQs5I8SmhHSm1UoDHgYw7zHg9fAPX6AN1Y0bJW
DVs69Q/6Xte6DmmJxGshbq6zhqqHbHQSKrYUsAAeA5dNHlnxfDitKxPqwJ46AFbe
g2Eeg5ErUzOAXFadYgIamGu7rBhETiM1uzMn+yRk3zSX5Hvv56oay0m+7fZBj01I
Za7YyXLwfs4aPDRjLlVyeto+T6Hm+JmGlpp6MCUvLU0/J25BUlu8I/9lWlicyEoO
vufzrpbZ8oigvMWywPxaCXSag7nKpVYx/bgtepnpAqy2vIUCYWxgYH/+jC/OnRjY
EhqhLm8kJSyJI27WQQDCY4Vqhei19vc5cwIBAg==
-----END DH PARAMETERS-----
EOF

  }

  type       = "Opaque"
  depends_on = [kubernetes_namespace.ingress-nginx]
}

resource "kubernetes_config_map" "ingress-nginx" {
  metadata {
    name      = "nginx-configuration"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  data = {
    hsts                    = "false"
    hsts-include-subdomains = "false"
    hsts-max-age            = "0"
    hsts-preload            = "false"
    ssl-dh-param            = "ingress-nginx/ingress-dhparams"
    use-forwarded-headers   = "true"
  }

  depends_on = [kubernetes_namespace.ingress-nginx]
}

resource "kubernetes_service" "ingress-nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }

    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
    }
  }

  spec {
    external_traffic_policy = "Local"
    type                    = "NodePort"
    // load_balancer_ip        = var.ingress-load-balancer-ip

    selector = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }

    port {
      name        = "http"
      port        = "80"
      target_port = "http"
    }

    port {
      name        = "https"
      port        = "443"
      target_port = "https"
    }
  }

  depends_on = [kubernetes_namespace.ingress-nginx]
}

