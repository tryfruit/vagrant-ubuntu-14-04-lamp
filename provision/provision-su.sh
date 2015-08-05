#!/bin/bash

echo "# ---------------------------------------------------------- #"
echo "#             Installing base system packages                #"
echo "# ---------------------------------------------------------- #"

echo "# --------------- Update APT-GET repository ---------------- #"
sudo apt-get update
echo "# ------------------------ DONE ---------------------------- #"

echo "# --------------------- Installing MC ---------------------- #"
sudo apt-get install -y mc
echo "# ------------------------ DONE ---------------------------- #"

echo "# -------------------- Installing BASH --------------------- #"
sudo apt-get install -y bash
echo "# ------------------------ DONE ---------------------------- #"

echo "# -------------------- Installing GIT ---------------------- #"
sudo apt-get install -y git
echo "# ------------------------ DONE ---------------------------- #"

echo "# -------------------- Installing CURL --------------------- #"
sudo apt-get install -y curl
echo "# ------------------------ DONE ---------------------------- #"

echo "# ---------------------------------------------------------- #"
echo "#                  Installing LAMP stack                     #"
echo "# ---------------------------------------------------------- #"

echo "# ---------------- Installing APACHE & PHP ----------------- #"
sudo apt-get install -y apache2 php5 libapache2-mod-php5 php5-mcrypt php5-curl php5-mysql php5-gd php5-cli php5-dev 
echo "# ------------------------ DONE ---------------------------- #"

echo "# --------------------- Setup MCRYPT ----------------------- #"
php5enmod mcrypt
echo "# ------------------------ DONE ---------------------------- #"

echo "# -------------------- Installing MYSQL -------------------- #"
sudo apt-get install -y mysql-client
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt-get install -y mysql-server 
echo "# ------------------------ DONE ---------------------------- #"

echo "# ------------------- Restart services --------------------- #"
sudo service apache2 restart 
sudo service mysql restart

if [ $? -ne 0 ]; then
   echo "... Please Check the Install Services, There are some problems."
else
   echo "... Installed Services are OK."
fi

sudo rm -rf /var/www/html
echo "# ------------------------ DONE ---------------------------- #"

echo "# ----------------- Installing COMPOSER -------------------- #"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
echo "# ------------------------ DONE ---------------------------- #"




