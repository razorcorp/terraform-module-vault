# Project: terraform-module-vault
# Created by: Praveen Premaratne
# Created on: 01/01/2025 18:24


variable "host_ip" {
  type        = string
  description = "Host IP address to use for SSH"
}

resource "tls_private_key" "vault_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "vault_cert" {
  private_key_pem = tls_private_key.vault_key.private_key_pem

  validity_period_hours = 24 * 1825

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  subject {
    common_name  = "vault.service.consul"
    organization = "Razorcorp"
  }
}

locals {
  vault_tpl_vars = {
    VAULT_CONFIG  = "/etc/vault.d"
    VAULT_DATA    = "/var/vault"
    NODE_ID       = var.host_ip
    RESOURCE_ROOT = "/opt/resources/vault"
  }

  vault_template = templatefile("${path.module}/templates/vault.sh.tftpl", local.vault_tpl_vars)
}

resource "null_resource" "provisioner" {
  connection {
    host  = var.host_ip
    agent = true
  }

  provisioner "file" {
    source      = "${path.module}/resources"
    destination = "/opt"
  }

  provisioner "file" {
    content     = tls_private_key.vault_key.private_key_pem
    destination = "${local.vault_tpl_vars.RESOURCE_ROOT}/ssl/private-key.pem"
  }

  provisioner "file" {
    content     = tls_self_signed_cert.vault_cert.cert_pem
    destination = "${local.vault_tpl_vars.RESOURCE_ROOT}/ssl/full-chain.pem"
  }

  provisioner "file" {
    content     = local.vault_template
    destination = "${local.vault_tpl_vars.RESOURCE_ROOT}/scripts/vault.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod -R +x ${local.vault_tpl_vars.RESOURCE_ROOT}/scripts",
      "${local.vault_tpl_vars.RESOURCE_ROOT}/scripts/init.sh",
      "${local.vault_tpl_vars.RESOURCE_ROOT}/scripts/vault.sh",
    ]
  }
}