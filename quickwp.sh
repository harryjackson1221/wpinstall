#!/bin/bash

#Created by KyleM (AKA Wered) and HarryJ
#version 1.2.3

cat << "EOF"
________          .__          __      __      __ __________ 
\_____  \   __ __ |__|  ____  |  | __ /  \    /  \\______   \
 /  / \  \ |  |  \|  |_/ ___\ |  |/ / \   \/\/   / |     ___/
/   \_/.  \|  |  /|  |\  \___ |    <   \        /  |    |    
\_____\ \_/|____/ |__| \___  >|__|_ \   \__/\  /   |____|    
       \__>                \/      \/        \/            
EOF



wget https://wordpress.org/latest.tar.gz --no-check-certificate 
tar -xzf latest.tar.gz 
cd wordpress 
cp -rf . .. 
cd .. 
rm -R wordpress 
cp wp-config-sample.php wp-config.php
PASSWDDB="$(date | sha256sum | base64 | head -c 8 )"; DBNAME="$(date | sha256sum | base64 | head -c 4 )";
p=$(pwd | cut -d/ -f3)
# (in progress) mysql create $DBNAME; 
# (in progress) mysql create-user $DBNAME $PASSWDDB;

autop=$(echo $p | cut -c1-8);
echo $autop

echo $autop
echo "password:" $PASSWDDB
dbname="$autop"_"$DBNAME"
echo $dbname

mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'localhost';"

echo "DB privleges granted"

ohost=$(grep DB_HOST "wp-config.php" |cut -d "'" -f 4)
ousername=$(grep DB_USER "wp-config.php" | cut -d "'" -f 4)
opassword=$(grep DB_PASSWORD "wp-config.php" | cut -d "'" -f 4)
odbname=$(grep DB_NAME "wp-config.php" |cut -d "'" -f 4)


sed -i -e "s/$ohost/localhost/g" wp-config.php
sed -i -e "s/'$ousername'/'$dbname'/g" wp-config.php
sed -i -e "s/'$opassword'/'$PASSWDDB'/g" wp-config.php
sed -i -e "s/'$odbname'/'$dbname'/g" wp-config.php

chown -R $p:$p .

chown $p:nobody /home/$p/public_html
