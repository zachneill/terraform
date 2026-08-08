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