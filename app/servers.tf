resource "proxmox_virtual_environment_vm" "oapautapp01" {
  name = "oapautapp01"
  node_name = var.proxmox_controller_node
  clone {
    vm_id = proxmox_virtual_environment_vm.alma_template.id
  }
  agent {
    enabled = true
  }
  memory {
    dedicated = 10240
  }
  initialization {
    dns {
      servers = ["1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = "192.168.1.31/24"
        gateway = "192.168.1.1"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.oapautapp01_cloud_init.id
  }
}

resource "proxmox_virtual_environment_vm" "oapautapp02" {
  name = "oapautapp02"
  node_name = var.proxmox_controller_node
  
  clone {
    vm_id = proxmox_virtual_environment_vm.alma_template_custom.id
  }
  agent {
    enabled = true
  }
  memory {
    dedicated = 2048
  }
  initialization {
    dns {
      servers = ["1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = "192.168.1.32/24"
        gateway = "192.168.1.1"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.oapautapp02_cloud_init.id
  }
}
