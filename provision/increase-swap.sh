#!/bin/bash

echo "# --------------------- Increase SWAP ---------------------- #"
# size of swapfile in megabytes
swapsize=8192

# add read permission to /etc/fstab if not available
sudo chmod 644 /etc/fstab

# does the swap file already exist?
sudo grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
  sudo echo '# --> Swapfile not found. Adding swapfile.'
  sudo fallocate -l ${swapsize}M /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  sudo echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
else
  sudo echo '# --> Swapfile found. No changes made.'
fi

# output results to terminal
sudo df -h
sudo cat /proc/swaps
sudo cat /proc/meminfo | grep Swap
echo "# ------------------------ DONE ---------------------------- #"
