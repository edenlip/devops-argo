resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
  }
}

resource "kubernetes_secret" "argo_s3_credentials" {
  metadata {
    name      = "my-s3-credentials"
    namespace = kubernetes_namespace.argo.metadata.0.name
  }

  data = {
    accessKey = aws_iam_access_key.developer_access_key.id
    secretKey = aws_iam_access_key.developer_access_key.secret
  }
}

resource "helm_release" "argo" {
  name       = "argo"
  namespace  = kubernetes_namespace.argo.metadata.0.name
  chart      = "argo-workflows"
  repository = "https://argoproj.github.io/argo-helm"

  set {
    name  = "server.serviceType"
    value = "LoadBalancer"
  }
  set {
    name  = "server.servicePort"
    value = "80"
  }
  set {
    name  = "server.extraArgs[0]"
    value = "--auth-mode=server"
  }
  set {
    name  = "artifactRepository.s3.bucket"
    value = "argo-example545-bucket"
  }
  set {
    name  = "artifactRepository.s3.endpoint"
    value = "s3.amazonaws.com"
  }
  set {
    name  = "artifactRepository.s3.region"
    value = local.aws_region
  }
  set {
    name  = "artifactRepository.s3.accessKeySecret.name"
    value = kubernetes_secret.argo_s3_credentials.metadata.0.name
  }
  set {
    name  = "artifactRepository.s3.secretKeySecret.name"
    value = kubernetes_secret.argo_s3_credentials.metadata.0.name
  }

}

resource "kubernetes_role_binding" "argo_admin_role_binding" {
  metadata {
    name      = "default-admin"
    namespace = kubernetes_namespace.argo.metadata.0.name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "argo"
  }
}

resource "kubectl_manifest" "argo_workflow_manifests" {
  for_each  = data.kubectl_path_documents.argo_workflow_manifests.manifests
  yaml_body = each.value
}
