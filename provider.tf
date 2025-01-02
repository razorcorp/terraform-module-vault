# Project: terraform-module-vault
# Created by: Praveen Premaratne
# Created on: 01/01/2025 18:24

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}