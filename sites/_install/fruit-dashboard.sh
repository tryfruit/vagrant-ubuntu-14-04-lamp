#!/bin/bash

echo "# ---------------------------------------------------------- #"
echo "#       Setting up  your Github and Bitbucket account        #"
echo "# ---------------------------------------------------------- #"
echo "# ------------------ Setting up your git ------------------- #"
IFS= read -r -p "Please enter your GIT full name: " GithubName
git config --global --unset-all user.name
git config --global user.name "$GithubName"

IFS= read -r -p "Please enter your GIT email address: " GithubEmail
git config --global --unset-all user.email
git config --global user.email "$GithubEmail"

echo "# --------- Configuring repositories and SSH urls ---------- #"
# SRC repository (GitHub)
SRC_DIRECTORY="/var/www/fruit-dashboard"
SRC_REPOSITORY_URL="https://github.com/tryfruit/fruit-dashboard.git"
SRC_GIT_CONFIG_FILE=${SRC_DIRECTORY%%/}/.git/config
SRC_DEV_BRANCH='development'

# Config repository (GitHub)
CONFIG_DIRECTORY="/var/www/fruit-dashboard-config"
CONFIG_REPOSITORY_URL="https://github.com/tryfruit/fruit-dashboard-config.git"
CONFIG_GIT_CONFIG_FILE=${CONFIG_DIRECTORY%%/}/.git/config
echo "# ------------------------ DONE ---------------------------- #"

echo "# ---------------------------------------------------------- #"
echo "#                Installing FRUIT DASHBOARD                  #"
echo "# ---------------------------------------------------------- #"
echo "# ----------- Clone SOURCE project from GITHUB ------------- #"
git clone `echo $SRC_REPOSITORY_URL` --depth 1 `echo $SRC_DIRECTORY`
echo "# --> Please type your credentials for the Fruit Dashboard Source repo (GITHUB)"
cd `echo $SRC_DIRECTORY`
git config credential.helper store
git config --global push.default upstream
git push
echo "# ------------------------ DONE ---------------------------- #"

echo "# ------------ Clone CONFIG project from GITHUB ------------ #"
git clone `echo $CONFIG_REPOSITORY_URL` --depth 1 `echo $CONFIG_DIRECTORY`
echo "# ------------------------ DONE ---------------------------- #"

echo "# -------- Switch to the development branch on SRC --------- #"
cd `echo $SRC_DIRECTORY`
sed -i '/fetch/c\        fetch = +refs/heads/*:refs/remotes/origin/*' `echo $SRC_GIT_CONFIG_FILE`
git pull --depth 1
git checkout `echo $SRC_DEV_BRANCH`

echo "[branch \"$SRC_DEV_BRANCH\"]" >> `echo $SRC_GIT_CONFIG_FILE`
echo "    remote = origin" >> `echo $SRC_GIT_CONFIG_FILE`
echo "    merge = refs/heads/$SRC_DEV_BRANCH" >> `echo $SRC_GIT_CONFIG_FILE`
git pull
echo "# ------------------------ DONE ---------------------------- #"

echo "# ------------------ Install local CONFIG ------------------ #"
chmod 744 `echo $CONFIG_DIRECTORY/local/install.sh`
`echo $CONFIG_DIRECTORY/local/install.sh`
echo "# ------------------------ DONE ---------------------------- #"

echo "# ---------------- Update COMPOSER Packages ---------------- #"
cd `echo $SRC_DIRECTORY`
composer update
echo "# ------------------------ DONE ---------------------------- #"

echo "# ----------- Create DATABASE, MIGRATE and SEED ------------ #"
chmod 744 `echo $SRC_DIRECTORY/scripts/reset_database.sh`
`echo $SRC_DIRECTORY/scripts/reset_database.sh`
echo "# ------------------------ DONE ---------------------------- #"

echo "# ---------------- Create shortcut aliases ----------------- #"
echo '# Custom alias commands' | sudo tee -a /home/vagrant/.bashrc
echo "alias fds='cd /var/www/fruit-dashboard'" | sudo tee -a /home/vagrant/.bashrc
echo "alias fdc='cd /var/www/fruit-dashboard-config'" | sudo tee -a /home/vagrant/.bashrc
echo "alias fdd='mysql -u root -ppassword fruitdashboarddb'" | sudo tee -a /home/vagrant/.bashrc
echo "alias fdserve='cd /var/www/fruit-dashboard/;sh serve;'" | sudo tee -a /home/vagrant/.bashrc
echo "alias fdlog='cd /var/www/fruit-dashboard/app/storage/logs/; tail -f $(ls -t * | head -1);'" | sudo tee -a /home/vagrant/.bashrc
echo "# ------------------------ DONE ---------------------------- #"
