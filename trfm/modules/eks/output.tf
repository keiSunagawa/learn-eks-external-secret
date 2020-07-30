output "cluster_name" {
  value = "${aws_eks_cluster.main_eks.name}"
}

output "k8s_endpoint" {
  value = "${aws_eks_cluster.main_eks.endpoint}"
}
output "k8s_certificate" {
  value = "${aws_eks_cluster.main_eks.certificate_authority.0.data}"
}
output "kubectl_config" {
  value = "${data.template_file.kubectl_config.rendered}"
}
