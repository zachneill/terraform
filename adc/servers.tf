resource "proxmox_virtual_environment_vm" "adc_clone" {
  for_each = var.proxmox_adc_vm_map
  name = each.key
  node_name = var.proxmox_controller_node
  clone {
    vm_id = 101
    # vm_id = proxmox_virtual_environment_vm.windows_template.id
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
        address = each.value.address
        gateway = "192.168.1.1"
      }
    }
    user_account {
      username = "Administrator"
      password = var.proxmox_loc_admin_password
    }
    # user_data_file_id = proxmox_virtual_environment_file.windows_cloud_init.id
  }
}