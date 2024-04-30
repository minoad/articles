# Prepare Physical Host for Kubernetes 1.30 Vagrant Deployment with Calico

1. **Install Ubuntu 22.04 on your server:**
    - Download the Ubuntu 22.04 server ISO from the official Ubuntu website.
    - Burn the ISO to a bootable media (USB or DVD).
    - Insert the bootable media into your server and boot from it.
    - Follow the on-screen instructions to install Ubuntu 22.04.

2. **Update your system:**

    ```bash
    sudo apt update
    sudo apt upgrade
    ```

3. **Install libvirt and virtualbox:**

    ```bash
    sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtualbox vagrant
    ```

4. **Add your user to the libvirt group:**

    ```bash
    sudo adduser `id -un` libvirt
    ```

5. **Validate Installs**

    ```bash
    virsh list --all
    vagrant --version
    ```

6. **Create a new bridge:**
    - Get the name of your network interface using `ip route`.  Common response will be something like `enp4s0` or `wlp3s0`:

    ```bash
    ip route
    ```

    - Open the `/etc/netplan/01-netcfg.yaml` file in a text editor:

    ```bash
    sudo vi /etc/netplan/01-netcfg.yaml
    ```

    - Add the following configuration, replacing `eth0` with your network interface name:

    ```yaml
    network:
      version: 2
      renderer: networkd
      ethernets:
        enp4s0:
          dhcp4: no
      bridges:
        br0:
          interfaces: [enp4s0]
          dhcp4: yes
    ```

    - Save and close the file.

7. **Apply the configuration:**

    ```bash
    sudo netplan apply
    ```

8. **Verify the bridge:**

    ```bash
    ip addr show br0
    ```

9. **Configure Vagrant to use the bridge:**
    - In your `Vagrantfile`, configure the network as follows:

    ```ruby
    config.vm.network "public_network", bridge: "br0"
    ```
