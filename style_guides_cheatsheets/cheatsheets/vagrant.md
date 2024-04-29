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