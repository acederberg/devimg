

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
