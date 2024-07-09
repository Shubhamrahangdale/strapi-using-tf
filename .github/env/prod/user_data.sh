#!/bin/bash

#update package list
sudo apt update -y

# install nodejs 18 & npm
sudo apt install nodejs -y && sudo apt install -y npm

# update package list and install pm2(nodejs Process Manager 2)
sudo apt update -y && sudo npm install -g pm2

# go to directory to download code
cd /srv/

# clone strapi app 
git clone https://github.com/VyankateshwarTaikar/strapi2_product.git
cd strapi2_product/

# run application 
pm2 start npm --name strapi -- run start

#restart pm2 
sudo pm2 startup systemd
