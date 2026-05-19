terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.106.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.19.1"
    }
  }
  backend "s3" {
    bucket = var.r2_bucket_name
    key    = "terraform.tfstate"
    region = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    endpoints = {
      s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
    }
  }
}
provider "proxmox" {
  endpoint = "https://odpndmcnt01.ndm.zachneill.com:8006/"
  api_token = var.proxmox_api_token # PROXMOX_VE_API_TOKEN
  insecure = true
  random_vm_ids = true
  ssh {
    agent = true 
    username = "root"
    password = var.proxmox_loc_admin_password
  }
}