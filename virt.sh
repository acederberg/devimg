virt-install \
  --name debian-v13 \
  --cpu host \
  --memory 4096 \
  --vcpus 2 \
  --disk size=100 \
  --cdrom ./debian-live-13.1.0-amd64-gnome.iso

# --network bridge \
