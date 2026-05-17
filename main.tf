terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.106.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.19.1"
    }
  }
  backend "s3" {
    bucket = var.r2_bucket_name
    key    = "terraform.tfstate"
    region = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    endpoints = {
      s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
    }
  }
}
provider "proxmox" {
  endpoint = "https://odpndmcnt01.ndm.zachneill.com:8006/"
  api_token = var.proxmox_api_token # PROXMOX_VE_API_TOKEN
  insecure = true
  random_vm_ids = true
  ssh {
    agent = true 
    username = "root"
    password = var.proxmox_loc_admin_password
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_template" {
  name = "ubuntu-template"
  node_name = var.proxmox_controller_node
  template = true
  started = false
  machine = "q35"
  bios = "ovmf"
  description = "Ubuntu 26.04 LTS Template"
  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  efi_disk {
    datastore_id = "local-lvm"
    type = "4m"
  }

  disk {
    datastore_id = "local-lvm"
    file_id = proxmox_download_file.ubuntu_cloud_image.id
    interface = "virtio0"
    iothread = true 
    discard = "on"
    size = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      username = "loc_admin"
      password = var.proxmox_loc_admin_password
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name = var.proxmox_controller_node
  url = "https://cloud-images.ubuntu.com/releases/resolute/release/ubuntu-26.04-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_vm" "ubuntu_clone" {
  name = var.proxmox_new_vm_name
  node_name = var.proxmox_controller_node
  clone {
    vm_id = proxmox_virtual_environment_vm.ubuntu_template.id
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
        address = "192.168.1.11/24"
        gateway = "192.168.1.1"
      }
    }
    user_account {
      username = "loc_admin"
      password = var.proxmox_loc_admin_password
    }
  }
}

# output "vm_ipv4_address" {
#   value = proxmox_virtual_environment_vm.ubuntu_clone.ipv4_addresses[1][0]
# }