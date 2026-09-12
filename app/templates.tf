resource "proxmox_virtual_environment_vm" "alma_template" {
  name        = "alma-template"
  node_name   = var.proxmox_controller_node
  template    = true
  started     = false
  machine     = "q35"
  bios        = "ovmf"
  description = "AlmaLinux 10.2 Template"
  agent {
    enabled = true
  }
  cpu {
    cores = 2
    type  = "host"
  }
  memory {
    dedicated = 2048
  }
  efi_disk {
    datastore_id = "local-lvm"
    type         = "4m"
  }
  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_download_file.alma_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 60
  }
  initialization {
    user_account {
      username = "loc_admin"
      password = var.proxmox_loc_admin_password
    }
    datastore_id = "local-lvm"
  }
  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_download_file" "alma_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.proxmox_controller_node
  url          = "https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-latest.x86_64.qcow2"
  overwrite    = true
  overwrite_unmanaged    = true
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

resource "proxmox_virtual_environment_vm" "alma_template_custom" {
  name        = "alma-template-custom"
  node_name   = var.proxmox_controller_node
  template    = true
  started     = false
  machine     = "q35"
  bios        = "ovmf"
  description = "AlmaLinux 10.2 Template with Custom Image"
  agent {
    enabled = true
  }
  cpu {
    cores = 2
    type  = "host"
  }
  memory {
    dedicated = 2048
  }
  efi_disk {
    datastore_id = "local-lvm"
    type         = "4m"
  }
  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_download_file.alma_cloud_image_custom.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 60
  }
  initialization {
    user_account {
      username = "loc_admin"
      password = var.proxmox_loc_admin_password
    }
    datastore_id = "local-lvm"
  }
  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_download_file" "alma_cloud_image_custom" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.proxmox_controller_node
  url          = "https://git.aut.zachneill.com/api/packages/it/generic/aut-app-alma/0.0.1/AlmaLinux-10-GenericCloud-10.2-20260912.0.x86_64.qcow2"
  overwrite    = true
  overwrite_unmanaged    = true
}

resource "proxmox_virtual_environment_file" "alma_cloud_init_custom" {
  for_each = var.proxmox_app_vm_map
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.proxmox_controller_node

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: oapautapp02.aut.zachneill.com
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
    package_update: true
    runcmd:
      - ['systemctl', 'restart', 'qemu-guest-agent']
      - ['tailscale', 'up', '--auth-key=${var.tailscale_auth_key}']
    EOF 

    file_name = "user_data_cloud_init_custom.yaml"
  }
}