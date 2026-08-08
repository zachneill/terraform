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

# resource "proxmox_virtual_environment_file" "windows_cloud_init" {
#   for_each = var.proxmox_adc_vm_map
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name = var.proxmox_controller_node

#   source_raw {
#     data = <<-EOF
#     #cloud-config
#     hostname: ${each.key}.aut.zachneill.com
#     users:
#       - default
#       - name: loc_admin
#         sudo: ALL=(ALL) NOPASSWD:ALL
#         groups: 
#           - sudo
#         shell: /bin/bash
#         lock_passwd: false
#         passwd: ${var.proxmox_loc_admin_password_hashed}
#     chpasswd:
#       expire: false
#     ssh_pwauth: true
#     package_update: true
#     packages:
#       - qemu-guest-agent
#     runcmd:
#       - systemctl enable --now qemu-guest-agent
#       - ['sh', '-c', 'curl -fsSL https://tailscale.com/install.sh | sh']
#       - ['sh', '-c', "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf && echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf && sudo sysctl -p /etc/sysctl.d/99-tailscale.conf" ]
#       - ['tailscale', 'up', '--auth-key=${var.tailscale_auth_key}']
#     EOF

#     file_name = "user_data_windows_cloud_init.yaml"
#   }
# }