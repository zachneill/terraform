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

variable "proxmox_controller_node" {
  description = "Name of the Proxmox controller"
  type        = string
  default     = "odpndmcnt01"
}

variable "proxmox_plt_vm_map" {
  description = "Map of platform VM configurations"
  type        = map(object({
    address = string
  }))
}

variable "tailscale_auth_key" {
  type        = string
  description = "Tailscale auth key for node authentication"
}