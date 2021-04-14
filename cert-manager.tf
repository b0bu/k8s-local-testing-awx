resource kubernetes_namespace "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}
# ---- added by me to fill in for azure keyvault key pair
# --context in kubectl command at line 64 has also been changed 
data local_file "int-ca-cert" {
  filename = "${path.module}/self-cert/root-public-crt.pem"
}
data local_file "int-ca-key" {
  filename = "${path.module}/self-cert/root-private-key.pem"
} 
// resource null_resource "int-ca-cert" {
//   triggers = {
//     manifest_sha1 = sha1(data.local_file.int-ca-cert.content)
// }
// resource null_resource "int-ca-key" {
//   triggers = {
//     manifest_sha1 = sha1(data.local_file.int-ca-key.content)
// }
# ---- added by me to fill in for azure keyvault key pair

resource kubernetes_secret "ca-key-pair" {
  metadata {
    name      = "ca-key-pair"
    namespace = kubernetes_namespace.cert-manager.metadata[0].name
  }

  data = {
    "tls.crt" = data.local_file.int-ca-cert.content
    "tls.key" = data.local_file.int-ca-key.content
  }

  type = "Opaque"
}

data helm_repository "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource helm_release "cert-manager" {
  name       = "cert-manager"
  repository = data.helm_repository.jetstack.metadata[0].name
  chart      = "jetstack/cert-manager"
  version    = var.cert-manager-version
  namespace  = "cert-manager"

  # See Configuration for a list of options that can be set for this chart helm https://hub.helm.sh/charts/jetstack/cert-manager 
   set {
    name  = "installCRDs"
    value = "true"
  }
}

data local_file "cluster-issuer" {
  filename = "${path.module}/cert-manager-issuer.yaml"
}

resource null_resource "cluster-issuer" {
  triggers = {
    manifest_sha1 = sha1(data.local_file.cluster-issuer.content)
  }

  provisioner "local-exec" {
    command = "kubectl apply --context='docker-desktop' -f -<<EOF\n${data.local_file.cluster-issuer.content}\nEOF"
  }

  depends_on = [
    helm_release.cert-manager,
  ]
}
