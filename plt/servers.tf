resource "proxmox_virtual_environment_vm" "ubuntu_clone" {
  for_each = var.proxmox_plt_vm_map
  name = each.key
  node_name = var.proxmox_controller_node
  clone {
    vm_id = proxmox_virtual_environment_vm.ubuntu_template.id
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
        address = each.value.address
        gateway = "192.168.1.1"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init[each.key].id
  }
}
