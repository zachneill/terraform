resource "proxmox_virtual_environment_vm" "alma_clone" {
  for_each = var.proxmox_app_vm_map
  name = each.key
  node_name = var.proxmox_controller_node
  clone {
    vm_id = proxmox_virtual_environment_vm.alma_template.id
  }
  agent {
    enabled = true
  }
  memory {
    dedicated = 12288
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
    user_data_file_id = proxmox_virtual_environment_file.alma_cloud_init[each.key].id
  }
}

resource "proxmox_virtual_environment_file" "alma_cloud_init" {
  for_each = var.proxmox_app_vm_map
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.proxmox_controller_node

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${each.key}.aut.zachneill.com
    users:
      - default
      - name: loc_admin
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: 
          - sudo
        shell: /bin/bash
        lock_passwd: false
        passwd: ${var.proxmox_loc_admin_password_hashed}
    chpasswd:
      expire: false
    ssh_pwauth: true
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
      - git
      - realmd 
      - sssd 
      - adcli
      - samba-common-tools
      - oddjob 
      - oddjob-mkhomedir
      - krb5-workstation
      - whois
    runcmd:
      - systemctl enable --now qemu-guest-agent
      - ['sh', '-c', 'curl -fsSL https://tailscale.com/install.sh | sh']
      - ['sh', '-c', "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf && echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf && sudo sysctl -p /etc/sysctl.d/99-tailscale.conf" ]
      - ['tailscale', 'up', '--auth-key=${var.tailscale_auth_key}']
    EOF 

    file_name = "user_data_cloud_init.yaml"
  }
}