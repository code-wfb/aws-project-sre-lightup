# ==============================================================================
# PROJECT: SRE LightUp (Docker + Grafana Lab)
# DESCRIPTION: Provisionamento seguro e corrigido de infraestrutura para SRE.
# ==============================================================================

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Região padrão do laboratório
}

# 1. GRUPO DE SEGURANÇA (Porta 3000 aberta para contornar CGNAT/Rede local)
resource "aws_security_group" "k8s_sg" {
  name        = "lab-k8s-grafana-sg-secure"
  description = "Regras de rede - Laboratorio de Observabilidade SRE"

  # Entrada: Permite acesso ao painel do Grafana via IPv4
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # TROUBLESHOOTING: Regra IPv6 para sanar o desvio de rota local mencionado no post
  ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"] # Altere para o seu IP fixo/128 caso queira restringir ao seu terminal
  }

  # Saída: Liberada para a máquina baixar o Docker e a imagem do Grafana
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sre-lightup-security-group"
    Environment = "Lab-Production-Simulation"
    Project     = "SRE-LightUp"
    ManagedBy   = "Terraform"
    Owner       = "Wallace-Fonseca"
    CostCenter  = "Personal-Development"
  }
}

# 2. BUSCA AUTOMÁTICA DA AMI DO UBUNTU SERVER
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

# 3. INSTÂNCIA EC2 CORRIGIDA (Forçando associação de rede pública via ID)
resource "aws_instance" "k8s_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  
  # CORREÇÃO CRÍTICA: Vincula o Security Group por ID para evitar o default da AWS
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  
  # CORREÇÃO CRÍTICA: Força o provisionamento de um IP Público real com rota de internet
  associate_public_ip_address = true

  # Automação de Inicialização limpa e recuada (Evita quebras de sintaxe no shell script)
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo docker run -d -p 3000:3000 --name=grafana-sre-lab grafana/grafana-enterprise:latest
              EOF

  tags = {
    Name        = "SRE-Grafana-Server"
    Environment = "Lab-Production-Simulation"
    Project     = "SRE-LightUp"
    ManagedBy   = "Terraform"
    Owner       = "Wallace-Fonseca"
    CostCenter  = "Personal-Development"
    Compliance  = "Restricted-Access"
  }
}

# 4. OUTPUT (RETORNO DO LINK PRONTO NO TERMINAL)
output "link_do_grafana" {
  value       = "http://${aws_instance.k8s_server.public_ip}:3000"
  description = "URL de acesso ao painel do Grafana para gravacao do post"
}