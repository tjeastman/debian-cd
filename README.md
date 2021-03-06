debian-CD
==========
First install the simple-cdd package:
```
sudo apt-get install simple-cdd
```
Then run the following command to build the ISO image for the CD:
```
build-simple-cdd --profiles base,vm --auto-profiles base,vm --dist wheezy
```
The output file `images/debian-testing-amd64-CD-1.iso` is a bootable
Debian Wheezy install CD (even though it contains "testing" in the
name).

The base profile is based on the example preseed configuration file from Debian Wheezy:
```
https://www.debian.org/releases/wheezy/example-preseed.txt
```

Mount the ISO image to examine its contents:
```
sudo mount -o loop images/debian-testing-amd64-CD-1.iso /mnt/
```

Note that the `build-simple-cdd` command will automatically update an existing ISO image file to reflect changes
to `simple-cdd.conf` or the files in `profiles/`.

To test the install CD, first create a VM:
```
VBoxManage createvm --name "Debian Wheezy" --ostype Debian_64 --register
VBoxManage modifyvm "Debian Wheezy" --memory 2048
VBoxManage modifyvm "Debian Wheezy" --nic1 nat
VBoxManage modifyvm "Debian Wheezy" --vram 12 --accelerate3d on
VBoxManage createhd --filename ./disk.vdi --size 20480
VBoxManage storagectl "Debian Wheezy" --name SATA --add sata --portcount 1 --bootable on
VBoxManage storageattach "Debian Wheezy" --storagectl SATA --type hdd --port 0 --medium ./disk.vdi
```

Add an IDE controller to the VM and attach the install CD through the
primary master device:
```
VBoxManage storagectl "Debian Wheezy" --name IDE --add ide --bootable on
VBoxManage storageattach "Debian Wheezy" --storagectl IDE --type dvddrive --port 0 --device 0 --medium ./images/debian-testing-amd64-CD-1.iso
```

Start the VM:
```
VBoxManage startvm "Debian Wheezy" --type gui
```
All questions normally asked by the Debian installer have preseeded
answers.  The installation will proceed automatically after the
initial install prompt.  When complete, the installer will eject the
CD and shut down the VM.

Create a vagrant box:
```
vagrant package --base "Debian Wheezy"
```
