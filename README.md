# AWS Project SRE LightUp 🚀

Análise, correção e provisionamento de infraestrutura segura na AWS utilizando Terraform, com automação de bootstrap via Docker e monitoramento centralizado com Grafana.

---

## 📌 Sobre o Projeto

Este repositório contém a solução técnica para o laboratório **SRE LightUp**. O objetivo principal foi estruturar uma infraestrutura resiliente, corrigindo gargalos de rede anteriores, aplicando conceitos de *Least Privilege* (Mínimo Privilégio) no IAM, e automatizando a inicialização de serviços essenciais através do User Data da EC2.

### 🛠️ O que foi resolvido/implementado:
* **Infraestrutura como Código (IaC):** Provisionamento modular e limpo utilizando Terraform.
* **Segurança de Credenciais:** Configuração de ambiente local isolada via `.env` mapeado no `.gitignore` para evitar vazamento de chaves.
* **Automação de Bootstrap:** Script automatizado para instalação do Docker e Docker Compose na inicialização da instância.
* **Observabilidade:** Deploy automático do **Grafana** rodando em container para monitoramento ativo.
* **Correção de Rede:** Ajuste em Security Groups e tabelas de roteamento para garantir a comunicação segura dos serviços.

---

## 🏗️ Arquitetura da Solução

A estrutura provisionada na AWS consiste em:
* **VPC** customizada com subnets públicas/privadas.
* **Internet Gateway** configurado para comunicação externa da subnet pública.
* **Security Groups** restritivos, liberando apenas as portas necessárias (`22` para SSH, `3000` para Grafana).
* **EC2 Instance** (Ubuntu Server) atuando como o nó de aplicação/SRE.

---

## 🧰 Tech Stack

* **Cloud Provider:** AWS (EC2, VPC, IAM, Security Groups)
* **Infrastructure as Code:** Terraform
* **Containerization:** Docker / Docker Compose
* **Observability:** Grafana
* **SO Operacional:** Linux (Ubuntu Server)

---

## 🚀 Como Executar este Projeto

### 📋 Pré-requisitos
Antes de começar, você precisará ter instalado em sua máquina:
* [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.0+)
* [AWS CLI](https://aws.amazon.com/cli/) configurado com suas credenciais do IAM.

### 🔧 Passo a Passo

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/code-wfb/aws-project-sre-lightup.git](https://github.com/code-wfb/aws-project-sre-lightup.git)
   cd aws-project-sre-lightup

   Configure suas variáveis de ambiente:
    Crie um arquivo .env na raiz do projeto (ele já está protegido pelo .gitignore) e adicione suas configurações da AWS:
    Code snippet

    AWS_PROFILE=seu-profile-ia
    AWS_DEFAULT_REGION=us-east-1

    Inicialize o Terraform:
    Bash

    terraform init

    Valide o plano de execução:
    Bash

    terraform plan

    Aplique a infraestrutura:
    Bash

    terraform apply -auto-approve

    Acessando o monitoramento:
    Após a finalização do Terraform, pegue o IP público gerado no outputs.tf e acesse no seu navegador:
    Plaintext

    http://<IP_PUBLICO_EC2>:3000

🧼 Destruindo os Recursos

Para evitar cobranças desnecessárias na sua conta AWS após os testes, destrua a infraestrutura executando:
Bash

terraform destroy -auto-approve