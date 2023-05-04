locals {
  elasticsearch_name = "elasticsearch"
}

resource "kubernetes_namespace" "elasticsearch" {
  metadata {
    name = "elasticsearch"
  }
}

resource "helm_release" "elasticsearch" {
  name      = local.elasticsearch_name
  chart     = "../helm-charts/elasticsearch"
  namespace = kubernetes_namespace.elasticsearch.metadata.0.name

  set {
    name  = "nameOverride"
    value = local.elasticsearch_name
  }

  set {
    name  = "fullnameOverride"
    value = local.elasticsearch_name
  }

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.elasticsearch.metadata.0.name
  }

  values = [
    data.template_file.elasticsearch.rendered,
  ]
}

data "template_file" "elasticsearch" {
  template = file("elasticsearch.yaml")
  vars = {
  }
}
