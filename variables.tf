variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Região da AWS para o deploy"
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Tipo de instância recomendada para laboratórios SRE"
}

variable "project_name" {
  type        = string
  default     = "sre-lightup"
  description = "Nome base do projeto"
}

variable "common_tags" {
  type        = map(string)
  default     = {
    Environment = "Lab-Production-Simulation"
    Project     = "SRE-LightUp"
    ManagedBy   = "Terraform"
    Owner       = "Wallace-Fonseca"
    CostCenter  = "Personal-Development"
  }
  description = "Tags de FinOps e Governança mapeadas no post"
}