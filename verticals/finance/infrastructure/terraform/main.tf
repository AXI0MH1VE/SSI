terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region for Finance SSI infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Deployment environment (dev|staging|prod)"
  type        = string
  default     = "prod"
}

variable "service_name" {
  description = "Base service name"
  type        = string
  default     = "ssi-finance"
}

locals {
  name_prefix = "${var.service_name}-${var.env}"
  tags = {
    Project     = "SSI"
    Vertical    = "Finance"
    Environment = var.env
    Owner       = "AxiomHive"
  }
}

resource "aws_kms_key" "signing" {
  description             = "KMS key for credential signing (FIPS 140-2)"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  tags                    = local.tags
}

resource "aws_ssm_parameter" "api_key" {
  name  = "/${local.name_prefix}/api_key"
  type  = "SecureString"
  value = "CHANGE_ME"
  tags  = local.tags
}

resource "aws_iam_role" "task" {
  name               = "${local.name_prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json
  tags               = local.tags
}

data "aws_iam_policy_document" "task_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${local.name_prefix}-cluster"
  tags = local.tags
}

resource "aws_ecs_task_definition" "api" {
  family                   = "${local.name_prefix}-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.task.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name  = "api"
      image = var.api_image
      portMappings = [{ containerPort = 8080, hostPort = 8080 }]
      environment = [
        { name = "ENV", value = var.env },
        { name = "VERTICAL", value = "finance" },
        { name = "KMS_KEY_ID", value = aws_kms_key.signing.id }
      ]
      secrets = [
        { name = "API_KEY", valueFrom = aws_ssm_parameter.api_key.arn }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.aws_region
          awslogs-group         = "/${local.name_prefix}/api"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = local.tags
}

variable "api_image" {
  description = "Container image for the Finance API"
  type        = string
}

output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "task_family" {
  value = aws_ecs_task_definition.api.family
}
