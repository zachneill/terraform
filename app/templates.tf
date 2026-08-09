resource "proxmox_virtual_environment_vm" "alma_template" {
  name        = "alma-template"
  node_name   = var.proxmox_controller_node
  template    = true
  started     = false
  machine     = "q35"
  bios        = "ovmf"
  description = "AlmaLinux 10.2 Template"
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
    file_id      = proxmox_download_file.alma_cloud_image.id
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

resource "proxmox_download_file" "alma_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.proxmox_controller_node
  url          = "https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-latest.x86_64.qcow2"
  overwrite    = true
  overwrite_unmanaged    = true
}