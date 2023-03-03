resource "kubernetes_namespace" "this" {
  metadata {
    name = "k8s-2048"
  }
}

resource "kubernetes_deployment" "this" {
  
  metadata {
    name      = "2048"
    namespace = "k8s-2048"
  }

  spec {
    replicas = 5
    selector {
      match_labels = {
        app = "2048"
      }
    }
    template {
      metadata {
        labels = {
          app = "2048"
        }
      }
      spec {
        container {
          image             = "alexwhen/docker-2048"
          image_pull_policy = "Always"
          name              = "2048"
          port {
            container_port = 80
            protocol       = "TCP"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "this" {

  metadata {
    name      = "myservice2"
    namespace = "k8s-2048"
  }

  spec {
    type = "NodePort"

    port {
      port = 80
    }

    selector = {
      app = kubernetes_deployment.this.spec.0.template.0.metadata.0.labels.app
    }
  }
} 