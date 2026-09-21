resource "proxmox_virtual_environment_vm" "oupautplt01" {
  name = "oupautplt01"
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
        address = "192.168.1.11/24"
        gateway = "192.168.1.1"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.oupautplt01_cloud_init.id
  }
}

resource "proxmox_virtual_environment_file" "oupautplt01_cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.proxmox_controller_node

  source_raw {
    data = <<-EOF
    #cloud-config
    fqdn: oupautplt01.aut.zachneill.com
    users:
      - default
      - name: loc_admin
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: 
          - sudo
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

    file_name = "oupautplt01_cloud_init.yaml"
  }
}