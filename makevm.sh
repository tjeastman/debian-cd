#!/bin/sh
VM_NAME="$1"
VM_BASE_DIR="$HOME/VirtualBox VMs/"
VM_DISK_NAME="$VM_BASE_DIR/$VM_NAME.vdi"
VM_ISO_FILE="./images/debian-8.0-amd64-CD-1.iso"
VBoxManage createvm --name "$VM_NAME" --ostype Debian_64 --register
VBoxManage modifyvm "$VM_NAME" --audio none
VBoxManage modifyvm "$VM_NAME" --usb off
VBoxManage modifyvm "$VM_NAME" --memory 512
#VBoxManage modifyvm "$VM_NAME" --nic1 bridged
#VBoxManage modifyvm "$VM_NAME" --bridgeadapter1 eth1
VBoxManage modifyvm "$VM_NAME" --vram 12 --accelerate3d on
VBoxManage createhd --filename "$VM_DISK_NAME" --size 20480
VBoxManage storagectl "$VM_NAME" --name SATA --add sata --portcount 1 --bootable on
VBoxManage storageattach "$VM_NAME" --storagectl SATA --type hdd --port 0 --medium "$VM_DISK_NAME"
VBoxManage storagectl "$VM_NAME" --name IDE --add ide --bootable on
VBoxManage storageattach "$VM_NAME" --storagectl IDE --type dvddrive --port 0 --device 0 --medium "$VM_ISO_FILE"
#VBoxManage startvm "$VM_NAME" --type gui
