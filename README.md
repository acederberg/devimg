


# Notes about `libvirt`




## Connecting to the Virtual Machine to Setup

In my experience so far, it is not possible to open a console directly to the 
box before doing this.

```sh
vncviewer $( virsh vncdisplay --domain $MY_DOMAIN )
```

It seems to be necessary to go through here the first time to get the virtual
machine initialized.


# Placeholder Readme

This `README` is here because poetry complains when it is not here.
For insightful notes on what I am doing here, please see the `notebooks`
directory.





