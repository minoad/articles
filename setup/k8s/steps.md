# Establish initial Kubernetes cluster

## Some config

```shell
# dmesg: read kernel buffer failed: Operation not permitted
sudo sysctl kernel.dmesg_restrict=0

$ sudo apt install virtualbox
$ sudo apt install virtualbox-dkms

# Manual commands for vbox
VBoxManage createhd --filename "node-01-disk.vdi" --size 20000 --format VDI
VBoxManage storagectl "node-01" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "node-01" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "node-01-disk.vdi"
VBoxManage startvm "node-01"
VBoxManage startvm "node-01" --headless
VBoxManage startvm "node-01" --type=headless
```

```
v unregistervm node-01
dmesg
ls -alhrt ~/VirtualBox\ VMs
date
export TF_LOG=DEBUG
terraform init -upgrade
v list runningvms
v showinfo
nvim README.md
vboxmanage showvminfo
vboxmanage showvminfo "k8s-node-C7j8"
v guestproperty enumerate "k8s-node-C7j8"
ssh 102.168.86.34
cat main.tf
ping 102.168.86.34
ssh 192.168.86.34
nvim main.tf
cat user_data
cat ~/.ssh/id_rsa.pub
cat ~/.ssh/authorized_keys
cc ~/.ssh/authorized_keys
vim user_data
v unregistervm k8s-node-C7j8
v controlvm --poweroff k8s-node-C7j8
v controlvm k8s-node-C7j8 --poweroff
cat README.md| grep poweroff
vboxmanage controlvm k8s-node-C7j8 poweroff
cat README.md| grep delete
vboxmanage unregistervm k8s-node-C7j8 --delete
vl
terraform apply
```



## Note

These are some of the most commonly used `VBoxManage` commands. VirtualBox provides extensive functionality and configuration options that you can explore through the `VBoxManage` command-line tool. For more detailed information on specific commands and their options, refer to the [official VirtualBox documentation](https://www.virtualbox.org/manual/).

