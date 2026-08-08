module "adc" {
  source = "./adc"

  proxmox_adc_vm_map      = var.proxmox_adc_vm_map
  proxmox_loc_admin_password = var.proxmox_loc_admin_password
  proxmox_loc_admin_password_hashed = var.proxmox_loc_admin_password_hashed
  proxmox_controller_node = var.proxmox_controller_node
  tailscale_auth_key      = var.tailscale_auth_key
}

module "plt" {
  source = "./plt"

  proxmox_plt_vm_map      = var.proxmox_plt_vm_map
  proxmox_loc_admin_password = var.proxmox_loc_admin_password
  proxmox_loc_admin_password_hashed = var.proxmox_loc_admin_password_hashed
  proxmox_controller_node = var.proxmox_controller_node
  tailscale_auth_key      = var.tailscale_auth_key
}

module "app" {
  source = "./app"

  proxmox_app_vm_map      = var.proxmox_app_vm_map
  proxmox_loc_admin_password = var.proxmox_loc_admin_password
  proxmox_loc_admin_password_hashed = var.proxmox_loc_admin_password_hashed
  proxmox_controller_node = var.proxmox_controller_node
  tailscale_auth_key      = var.tailscale_auth_key
}