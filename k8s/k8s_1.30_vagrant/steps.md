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

# `VBoxManage` Cheatsheet

This cheatsheet covers commonly used `VBoxManage` commands for managing VirtualBox virtual machines and resources.

## VM Management

- **List all registered VMs**: Lists all registered virtual machines with their names and UUIDs.

    ```shell
    VBoxManage list vms
    ```

- **List running VMs**: Lists currently running virtual machines with their names and UUIDs.

    ```shell
    VBoxManage list runningvms
    ```

- **Show VM info**: Displays detailed information about a specific VM. Replace `"VM Name or UUID"` with the name or UUID of the VM.

    ```shell
    VBoxManage showvminfo "VM Name or UUID"
    ```

- **Start a VM**: Starts a specific VM. Replace `"VM Name or UUID"` with the name or UUID of the VM.

    ```shell
    VBoxManage startvm "VM Name or UUID" --type headless
    ```

- **Stop a VM**: Stops a running VM. Replace `"VM Name or UUID"` with the name or UUID of the VM.

    ```shell
    VBoxManage controlvm "VM Name or UUID" poweroff
    ```

- **Pause a VM**: Pauses a running VM. Replace `"VM Name or UUID"` with the name or UUID of the VM.

    ```shell
    VBoxManage controlvm "VM Name or UUID" pause
    ```

- **Resume a paused VM**: Resumes a paused VM. Replace `"VM Name or UUID"` with the name or UUID of the VM.

    ```shell
    VBoxManage controlvm "VM Name or UUID" resume
    ```

- **Take a snapshot**: Takes a snapshot of a VM. Replace `"VM Name or UUID"` with the name or UUID of the VM.

    ```shell
    VBoxManage snapshot "VM Name or UUID" take "Snapshot Name"
    ```

- **Restore a snapshot**: Restores a VM to a specific snapshot.

    ```shell
    VBoxManage snapshot "VM Name or UUID" restore "Snapshot Name"
    ```

- **Delete a VM**: Deletes a VM. Replace `"VM Name or UUID"` with the name or UUID of the VM.

    ```shell
    VBoxManage unregistervm "VM Name or UUID" --delete
    ```

## Network Management

- **List host-only interfaces**: Lists all host-only interfaces available in VirtualBox.

    ```shell
    VBoxManage list hostonlyifs
    ```

- **Create a host-only network**: Creates a new host-only network interface.

    ```shell
    VBoxManage hostonlyif create
    ```

- **Remove a host-only network**: Deletes a host-only network interface.

    ```shell
    VBoxManage hostonlyif remove "Interface Name"
    ```

- **List NAT networks**: Lists all NAT networks.

    ```shell
    VBoxManage list natnets
    ```

- **Create a NAT network**: Creates a new NAT network.

    ```shell
    VBoxManage natnetwork add --network "10.0.2.0/24" --enable
    ```

## Storage Management

- **List hard disks**: Lists all registered hard disks.

    ```shell
    VBoxManage list hdds
    ```

- **Create a new virtual hard disk**: Creates a new virtual hard disk.

    ```shell
    VBoxManage createmedium disk --filename "filename.vdi" --size 10240
    ```

- **Attach a disk to a VM**: Attaches an existing virtual hard disk to a VM.

    ```shell
    VBoxManage storageattach "VM Name" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "filename.vdi"
    ```

## Miscellaneous

- **List extension packs**: Lists all installed extension packs.

    ```shell
    VBoxManage list extpacks
    ```

- **Install an extension pack**: Installs an extension pack.

    ```shell
    VBoxManage extpack install "path_to_extpack"
    ```

- **Uninstall an extension pack**: Uninstalls an extension pack.

    ```shell
    VBoxManage extpack uninstall "Extension Pack Name"
    ```

- **Show VirtualBox version**: Displays the version of VirtualBox installed on your system.

    ```shell
    VBoxManage --version
    ```

- **List supported OS types**: Lists all supported guest operating systems and their types.

    ```shell
    VBoxManage list ostypes
    ```

## Note

These are some of the most commonly used `VBoxManage` commands. VirtualBox provides extensive functionality and configuration options that you can explore through the `VBoxManage` command-line tool. For more detailed information on specific commands and their options, refer to the [official VirtualBox documentation](https://www.virtualbox.org/manual/).

