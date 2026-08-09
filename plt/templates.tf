resource "proxmox_virtual_environment_vm" "ubuntu_template" {
  name        = "ubuntu-template"
  node_name   = var.proxmox_controller_node
  template    = true
  started     = false
  machine     = "q35"
  bios        = "ovmf"
  description = "Ubuntu 26.04 LTS Template"
  agent {
    enabled = true
  }
  cpu {
    cores = 2
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
    file_id      = proxmox_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
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

resource "proxmox_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_controller_node
  url          = "https://cloud-images.ubuntu.com/releases/resolute/release/ubuntu-26.04-server-cloudimg-amd64.img"
  overwrite    = true
  overwrite_unmanaged    = true
}


resource "proxmox_virtual_environment_file" "ubuntu_cloud_init" {
  for_each = var.proxmox_plt_vm_map
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
      - sssd-tools
      - adcli
      - krb5-user
      - samba-common-bin
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