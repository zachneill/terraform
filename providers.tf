terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.22.0"
    }
  }
}
provider "proxmox" {
  endpoint      = "https://odpndmcnt01.ndm.zachneill.com:8006/"
  api_token     = var.proxmox_api_token # PROXMOX_VE_API_TOKEN
  insecure      = true
  random_vm_ids = true
  ssh {
    agent    = true
    username = "root"
    password = var.proxmox_loc_admin_password
  }
}