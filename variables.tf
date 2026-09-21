variable "proxmox_loc_admin_password" {
  description = "Password for loc_admin user"
  type        = string
  sensitive   = true
}

variable "proxmox_loc_admin_password_hashed" {
  description = "Hashed password for loc_admin user (mkpasswd -m sha-512)"
  type        = string
  sensitive   = true
}

variable "proxmox_svc_ansible_password" {
  description = "Password for svc_ansible user"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token" {
  description = "API token for Proxmox API"
  type        = string
  sensitive   = true
}

variable "proxmox_controller_node" {
  description = "Name of the Proxmox controller"
  type        = string
  default     = "odpndmcnt01"
}

variable "r2_bucket_name" {
  description = "Name of the R2 bucket for Terraform state"
  type        = string
  default     = "ccpndmr2b01"
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
}

variable "tailscale_auth_key" {
  type        = string
  description = "Tailscale auth key for node authentication"
}