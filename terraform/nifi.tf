locals {
  nifi_name = "nifi"
}

resource "kubernetes_namespace" "nifi" {
  metadata {
    name = "nifi"
  }
}

resource "helm_release" "nifi" {
  name      = local.nifi_name
  chart     = "../helm-charts/nifi"
  namespace = kubernetes_namespace.nifi.metadata.0.name

  set {
    name  = "nameOverride"
    value = local.nifi_name
  }

  set {
    name  = "fullnameOverride"
    value = local.nifi_name
  }

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.nifi.metadata.0.name
  }

  values = [
    data.template_file.nifi.rendered,
  ]

  timeout = 600
}

data "template_file" "nifi" {
  template = file("nifi.yaml")
  vars = {
  }
}
