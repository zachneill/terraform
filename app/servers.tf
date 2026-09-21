resource "proxmox_virtual_environment_file" "oapautapp01_cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.proxmox_controller_node

  source_raw {
    data = <<-EOF
    #cloud-config
    fqdn: oapautapp01.aut.zachneill.com
    users:
      - default
      - name: loc_admin
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: 
          - wheel
          - docker
        shell: /bin/bash
        lock_passwd: false
        passwd: ${var.proxmox_loc_admin_password_hashed}
    chpasswd:
      expire: false
    ssh_pwauth: true
    runcmd:
      - ['systemctl', 'restart', 'qemu-guest-agent']
      - ['tailscale', 'up', '--auth-key=${var.tailscale_auth_key}']
    EOF 

    file_name = "oapautapp01_cloud_init.yaml"
  }
}
resource "proxmox_virtual_environment_vm" "oapautapp01" {
  name = "oapautapp01"
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
        address = "192.168.1.31/24"
        gateway = "192.168.1.1"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.oapautapp01_cloud_init.id
  }
}

resource "proxmox_virtual_environment_file" "oapautapp02_cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.proxmox_controller_node

  source_raw {
    data = <<-EOF
    #cloud-config
    fqdn: oapautapp02.aut.zachneill.com
    users:
      - default
      - name: loc_admin
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: 
          - wheel
          - docker
        shell: /bin/bash
        lock_passwd: false
        passwd: ${var.proxmox_loc_admin_password_hashed}
    chpasswd:
      expire: false
    ssh_pwauth: true
    runcmd:
      - ['systemctl', 'restart', 'qemu-guest-agent']
      - ['tailscale', 'up', '--auth-key=${var.tailscale_auth_key}']
    EOF 

    file_name = "oapautapp02_cloud_init.yaml"
  }
}
# resource "proxmox_virtual_environment_vm" "oapautapp02" {
#   name = "oapautapp02"
#   node_name = var.proxmox_controller_node
  
#   clone {
#     vm_id = proxmox_virtual_environment_vm.alma_template_custom.id
#   }
#   agent {
#     enabled = true
#   }
#   memory {
#     dedicated = 2048
#   }
#   initialization {
#     dns {
#       servers = ["1.1.1.1"]
#     }
#     ip_config {
#       ipv4 {
#         address = "192.168.1.32/24"
#         gateway = "192.168.1.1"
#       }
#     }
#     user_data_file_id = proxmox_virtual_environment_file.oapautapp02_cloud_init.id
#   }
# }