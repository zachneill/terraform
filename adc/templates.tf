# resource "proxmox_virtual_environment_vm" "windows_template" {
#   name = "windows-template"
#   node_name = var.proxmox_controller_node
#   template = true
#   started = false
#   machine = "q35"
#   bios = "ovmf"
#   description = "Windows Server Core 2025 Template"
#   cpu {
#     cores = 2
#   }
#   memory {
#     dedicated = 4096
#   }
#   efi_disk {
#     datastore_id = "local-lvm"
#     type = "4m"
#   }
#   disk {
#     datastore_id = "local-lvm"
#     file_id = proxmox_download_file.windows_cloud_image.id
#     interface = "virtio0"
#     iothread = true 
#     discard = "on"
#     size = 20
#   }
#   initialization {
#     user_account {
#       username = "Administrator"
#       password = var.proxmox_loc_admin_password
#     }
#   }
# }

# resource "proxmox_download_file" "windows_cloud_image" {
#   content_type   = "iso"
#   datastore_id   = "local"
#   node_name      = var.proxmox_controller_node
#   url            = "https://software-static.download.prss.microsoft.com/dbazure/998969d5-f34g-4e03-ac9d-1f9786c66749/26100.32230.260111-0550.lt_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
#   upload_timeout = 1500
# }

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