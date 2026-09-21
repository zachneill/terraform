
resource "proxmox_virtual_environment_vm" "alma_template_custom" {
  name        = "alma-template-custom"
  node_name   = var.proxmox_controller_node
  template    = true
  started     = false
  stop_on_destroy = true
  machine     = "q35"
  bios        = "ovmf"
  description = "AlmaLinux 10.2 Template with Custom Image"
  agent {
    enabled = true
  }
  cpu {
    cores = 2
    type  = "host"
  }
  memory {
    dedicated = 2048
  }
  efi_disk {
    datastore_id = "local-lvm"
    type         = "4m"
  }
  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_download_file.alma_cloud_image_custom.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 60
  }
  initialization {
    user_account {
      username = "loc_admin"
      password = var.proxmox_loc_admin_password
    }
    datastore_id = "local-lvm"
  }
  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_download_file" "alma_cloud_image_custom" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.proxmox_controller_node
  url          = "https://git.aut.zachneill.com/api/packages/AUT/generic/aut-app-alma/0.0.3/AlmaLinux-10-GenericCloud-10.2-20260916.0.x86_64.qcow2"
  overwrite    = true
  overwrite_unmanaged    = true
}