#!/bin/bash

# Created by Harry Jackson - for use with 
# Current Version 0.1.0

cat << "EOF"
(GRAPHICS COMING SOON) :-)           
EOF

#Setting pwd as variable, may find a better way to do this later
CWD=$(pwd)

#Lets get some wordpress stuff
wget https://wordpress.org/latest.tar.gz --no-check-certificate 
tar -xzf "$CWD"/latest.tar.gz 
cd "$CWD"/wordpress 
cp -rf . "$CWD"
cd "$CWD"
rm -R "$CWD"/wordpress 
cp "$CWD"/wp-config-sample.php "$CWD"/wp-config.php

#Time to set a username and password randomly, and print out to suggest using
PASSWDDB="$(date | sha256sum | base64 | head -c 8 )"
DBNAME="$(date | md5sum | head -c 8 )"

#Username on CentOS 7 w/ cPanel - need to devise a way to ask for the file owner/user, dbhost dbname dbuser and pass
#p=$(pwd | cut -d/ -f3)
# (in progress) mysql create $DBNAME; 
# (in progress) mysql create-user $DBNAME $PASSWDDB;

#autop=$(echo $p | cut -c1-8);

#echo $autop

#echo $autop
#echo "password:" $PASSWDDB
#dbname="$autop"_"$DBNAME"
#echo $dbname

#mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'localhost';"

#echo "DB privleges granted"

ohost=$(grep DB_HOST "wp-config.php" |cut -d "'" -f 4)
ousername=$(grep DB_USER "wp-config.php" | cut -d "'" -f 4)
opassword=$(grep DB_PASSWORD "wp-config.php" | cut -d "'" -f 4)
odbname=$(grep DB_NAME "wp-config.php" |cut -d "'" -f 4)


sed -i -e "s/$ohost/localhost/g" wp-config.php
sed -i -e "s/'$ousername'/'$dbname'/g" wp-config.php
sed -i -e "s/'$opassword'/'$PASSWDDB'/g" wp-config.php
sed -i -e "s/'$odbname'/'$dbname'/g" wp-config.php

#Using sed with regex to complete instead
#sed -r \
#    "
#        s/define\(([\"'])DB_(NAME|USER)\1,\s*([\"']).*\2/define(\1DB_NAME\1, \2${dbname}\2/g;
#        s/define\(([\"'])DB_PASSWORD\1,\s*([\"']).*\2/define(\1DB_NAME\1, \2${PASSWDDB}\2/g;
#        s/define\(([\"'])DB_HOST\1,\s*([\"']).*\2/define(\1DB_NAME\1, \2localhost\2/g;
#    " \
#    -i wp-config.php

#chown -R $p:$p .

#chown $p:nobody /home/$p/public_html
