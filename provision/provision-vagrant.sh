#!/bin/bash

echo "# ---------------------------------------------------------- #"
echo "#              Installing User related stuff                 #"
echo "# ---------------------------------------------------------- #"

echo "# ------------------ Generating SSH key -------------------- #"
ssh-keygen -b 4096 -t rsa -f ~/.ssh/id_rsa -P ""
eval `ssh-agent -s`
ssh-add
echo "# ------------------------ DONE ---------------------------- #"
