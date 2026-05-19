resource "proxmox_virtual_environment_vm" "ubuntu_clone" {
  name = var.proxmox_new_vm_name
  node_name = var.proxmox_controller_node
  clone {
    vm_id = proxmox_virtual_environment_vm.ubuntu_template.id
  }
  agent {
    enabled = true
  }
  memory {
    dedicated = 8192
  }
  initialization {
    dns {
      servers = ["1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = "192.168.1.11/24"
        gateway = "192.168.1.1"
      }
    }
    user_account {
      username = "loc_admin"
      password = var.proxmox_loc_admin_password
    }
  }
}