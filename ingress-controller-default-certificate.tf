# --context at line 12 has been changed to docker-desktop
data local_file "default-certificate-resource" {
  filename = "${path.module}/ingress-controller-default-certificate.yaml"
}

resource null_resource "default-certificate-resource" {
  triggers = {
    manifest_sha1 = sha1(data.local_file.default-certificate-resource.content)
  }

  provisioner "local-exec" {
    command = "kubectl apply --context='docker-desktop' -f -<<EOF\n${data.local_file.default-certificate-resource.content}\nEOF"
  }

  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
}