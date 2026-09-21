resource "proxmox_virtual_environment_vm" "ubuntu_template" {
  name        = "ubuntu-template"
  node_name   = var.proxmox_controller_node
  template    = true
  started     = false
  machine     = "q35"
  bios        = "ovmf"
  description = "Ubuntu 26.04 LTS Template"
  stop_on_destroy = true

  agent {
    enabled = true
  }
  cpu {
    cores = 2
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
    file_id      = proxmox_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
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

resource "proxmox_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.proxmox_controller_node
  url          = "https://ccpndmr2b02.ndm.zachneill.com/Ubuntu-26-ServerCloud-26.04.qcow2"
  overwrite    = true
  overwrite_unmanaged    = true
}