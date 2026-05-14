variable "proxmox_loc_admin_password" {
  description = "Password for loc_admin user"
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

variable "proxmox_new_vm_name" {
  description = "Name of the new VM to be created"
  type        = string
}