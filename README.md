


# Notes about `libvirt`




```sh
MY_DOMAIN=...
```

## Setting up a Virtual Network

```sh
virsh --connect qemu:///system net-define network.xml
virsh --connect qemu:///system net-start network.xml
virsh --connect qemu:///system net-autostart network.xml
```


## Setting up a Virtual Machine 


```sh
virsh define debian.xml
```


## Connecting to the Virtual Machine to Setup

In my experience so far, it is not possible to open a console directly to the 
box before doing this.

```sh
vncviewer $( virsh vncdisplay --domain $MY_DOMAIN )
```

It seems to be necessary to go through here the first time to get the virtual
machine initialized.


## Removing the Disk After Setup

To list all of the disks attached to the virtual machine, run
`virsh domblklist --domain devimg-debian-13`. This will show the attached 
storage devices - look for the ISO under this list and copy the source. 
To detach this, run `virsh detach-disk --domain devimg-debian-13 '/path/to/my/iso' --config`.


# How to get a Terminal?    

## What the hell is a `pty`?

First, a `tty` is just an abstract representation of historical devices like
teletypes and physical terminals, it literally stands for `teletypewriter`.
A `pty` is a psuedoterminal.

## What the hell is `/dev/ttys0`?

This is the file representing a literal serial port on linux systems.
It can be configured with `/etc/init/ttyS0.conf`.

## Configuring Grub

Grub can be used to configure `/dev/ttys0`, in particular through `/etc/default/grub`.


# How to skip the annoying install steps?

The two major options appear to be providing preseed files or `cloud-init`.

## Cloud-Init

This bypasses the setup steps directly.
Often there are versions available for cloud free situations, such as running
virtual machines on bare metal. For example, see [the Debian official cloud images](https://cloud.debian.org/images/cloud/).


## Pre-seed Configuration

This can be a pain in the ass since

1. It must be determined how to provide the pre-seed configuration on install,
2. The format of said file tends to vary widely.


# Notes About Composer

`composer` is necessary to make it possible to run `rhel10` as a cloud image.

- [Building golden images](https://www.redhat.com/en/blog/linux-golden-homelab-rhel)
- [Golden images](https://cloud.redhat.com/learning/learn:how-build-and-upload-red-hat-enterprise-linux-rhel-image-image-builder/resource/resources:creating-system-images-rhel-image-builder-using-cli)
- [What the hell is image mode?](https://developers.redhat.com/products/rhel-image-mode/getting-started?extIdCarryOver=true&intcmp=701f20000012ngPAAQ&sc_cid=7013a0000034ndkAAA)
- [Bootc](https://github.com/bootc-dev/bootc)
- [Bootc image builder](https://github.com/osbuild/bootc-image-builder?tab=readme-ov-file)

For further details, see the playbooks `./playbooks/testing/rhel.yaml`.
Additionally, it is possible to build customized redhat images with the 
[Redhat Console's Image Builder](https://console.redhat.com/insights/image-builder)
instead of with `weldr`/`composer-cli`/`composer`.

## Notes About the Images Output By Composer

It is important to note that the images that composer outputs are not immediately
compatible with `virt-customize`. For instance, the image I downloaded from the 
redhat console image builder would raise the following error:

```stdout

```

But would still function when I ran the playbooks I used for `Debian` minus the
customization step. This is because the image would appear to be in the 
so-called `image-mode`. Running `virt-inspector /var/lib/libvirt/images/rhel-10.0-x86_64-kvm.qcow2`
would print out absolutely nothing, which is strange in comparison to running the
`virt-inspector` against a `debian` image.

### Notes About Image Mode

Image mode is compatible with QEMU - QEMU is the underlying framework for 
`openshift`, `libvirt`, and `proxmox` - all of which I use frequently.


### Notes About Bootc

`bootc` is a library used for 'Transactional, in-place OS updates using OCI/Docker
container images'. Along with this, there is the `bootc-image-builder` which
can be run as a container. `bootc` is used to convert container
images into bootable virtual machine images for various platforms.

Further, my observation is that the `bootc-image-builder` configuration is exactly
the configuration used by `composer-cli`. For instance, it is possible to 
specify a user like


```
[[customizations.user]]
name = "ansible"
password = "ansible"
key = "ssh-ed25519  ...."
groups = ["wheel"]
```


Using roughly this configuration and the `docker-compose.yaml` provided in this
project I managed to cook up a `qcow` image. For whatever reason, the 
necessary tools to modify this using `libvirt-customize` has continued to evade
me, so I will just use the `bootc-image-builder` instead.






# Glossary of Helpful Commands

- `virsh` - The primary command used to manage virtualized resources in `qemu`.
- `virt-customize` - The customization command for prebaked (e.g. guest machine)
  disks. 
- `virt-filesystems` - This can be used to inspect disks that have been downloaded.
- `qemu-img` - Analysis of various image formats. In my case, especially helpful
  for inspecting `qcow` images.

