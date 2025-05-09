packer {
  required_plugins {
    xenserver = {
      version = "= v0.7.3"
      source  = "github.com/ddelnano/xenserver"
    }
  }
}

variable "remote_host" {
  type        = string
  description = "The ip or fqdn of your XCP-ng. It must be the master"
  sensitive   = true
  default     = "your xcp master server ip"
}

variable "remote_username" {
  type        = string
  description = "The username used to interact with your XCP-ng"
  sensitive   = true
  default     = "master server username"
}

variable "remote_password" {
  type        = string
  description = "The password used to interact with your XCP-ng"
  sensitive   = true
  default     = "master server password"
}

variable "sr_iso_name" {
  type        = string
  description = "The ISO-SR to packer will use"
  default     = "ISO"
}

variable "sr_name" {
  type        = string
  description = "The name of the SR to packer will use"
  default     = "Local storage"
}

source "xenserver-iso" "windows_server" {
  # Provide checksum for your Windows ISO
  # iso_checksum = "sha256:YOUR_ISO_CHECKSUM"  # Replace with actual checksum (optional)
  
  # Change the iso_url to point to your local storage where the ISO is
  iso_name = "WindowsServer_Unattended.iso"

  
  sr_iso_name    = var.sr_iso_name
  sr_name        = var.sr_name
  tools_iso_name = ""  # Optional, if you have a tools ISO for Windows

  remote_host     = var.remote_host
  remote_password = var.remote_password
  remote_username = var.remote_username

  http_directory = "http"  # If you have an HTTP preseed.cfg file for Windows, you can specify the directory
  
  boot_command = [
    "<wait><wait><wait><esc><wait><wait><wait>",  # Adjust this to the Windows Server installation process
    "/bootmgr ",
    "initrd=/boot/bootx64.efi ",
    "auto=true ",
    "interface=auto ",
    "vga=788 noprompt quiet<enter>",
    "<wait><wait><wait>",  # Ensure there's enough wait time
    "autounattend=http://{{.HTTPIP}}:{{.HTTPPort}}/autounattend.xml<enter>"  # Point to your autounattend.xml file
]



  vm_name         = "Windows Server Template"  # Update with the desired VM name
  vm_description  = "Windows Server template with Packer"
  vcpus_max       = 2
  vcpus_atstartup = 2
  vm_memory       = 4096  # Adjust memory for Windows Server (in MB)
  network_names   = ["eth0"]
  disk_size       = 20408  # In MB, adjust disk size for Windows Server
  disk_name       = "windows_server_disk"
  vm_tags         = ["Generated by Packer"]

  # Set up the Windows user for SSH (if you're using SSH provisioning)
  ssh_username           = "Administrator"  # Windows default username
  ssh_password           = "windows password"  # Set the Windows password
  ssh_wait_timeout       = "60000s"
  ssh_handshake_attempts = 10000

  output_directory = "packer-windows-server"
  keep_vm          = "never"
  format           = "xva_compressed"
}

build {
  sources = ["xenserver-iso.windows_server"]
}
