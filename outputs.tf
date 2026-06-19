output "link_do_grafana" {
  value       = "http://${aws_instance.k8s_server.public_ip}:3000"
  description = "URL de acesso direto ao painel do Grafana gerada no terminal"
}