# On-prem Vault deployment

Terraform module for provisioning Vault sever for on-prem and baremetal servers with `null_resource` provider.

Module uses SSH to configure the host similar to Ansible using Bash scripts generated with Terraform templates.

> If bundled with other `null_resource` provisioners, consider chaining them with `depends_on` or set `-parallelism=1` to avoid package manager issues such as APT or DPKG lock

## Inputs
- `host_ip` - Host IP address to use for SSH

### Example
```terraform
module "provisioner" {
  source         = "git@github.com:razorcorp/terraform-module-vault.git?ref=master"
  host_ip        = "10.10.1.12"
}
```