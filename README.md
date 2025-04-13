# Windows Server 2022 Packer Template for XCP-ng

This repository contains a Packer template and associated XML configuration to automate the creation of a **Windows Server 2022** virtual machine on **XCP-ng** using Packer.

## Requirements

- [Packer](https://www.packer.io/) (Ensure you have the latest version installed)
- **XCP-ng** or **XenServer** environment for virtualization
- A **Windows Server 2022 ISO** to be used in the Packer template
- [XenServer Packer builder plugin](https://github.com/vatesfr/terraform-provider-xenorchestra) (for building images on XCP-ng)

## Files Included

- **`packer_template.pkr.hcl`**: The main Packer template that defines the configuration for the Windows Server 2022 image.
- **`autounattend.xml`**: The XML file used for automating Windows Server 2022 installation.
- **`scripts/`**: Directory containing any supporting scripts (if any).
  
## Setup and Usage

### 1. Install Packer

Make sure that [Packer](https://www.packer.io/downloads) is installed on your local machine.

```bash
# On macOS (using Homebrew)
brew install packer

# On Windows, follow the instructions at https://www.packer.io/downloads
