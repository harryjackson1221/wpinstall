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
DBUNAME="$()"

#Username on CentOS 7 w/ cPanel - need to devise a way to ask for the file owner/user, dbhost dbname dbuser and pass
#p=$(pwd | cut -d/ -f3)

echo "WP Database Name: "
read -e dbname
echo "WP Database User: "
read -e dbuser
echo "WP Database Password: "
read -s dbpass
echo "WP Database Table Prefix [numbers, letters, and underscores only] (Enter for default 'wp_'): "
read -e dbtable
        dbtable=${dbtable:-wp_}
echo "Do you need to setup new MySQL database? (y/n)"
read -e setupmysql
if [ "$setupmysql" == y ] ; then
	echo "************************"
	echo "Setting up the database."
	echo "------------------------"
	#login to MySQL, add db, add user and grant permissions to db
	dbsetup="create database $dbname;GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@$mysqlhost IDENTIFIED BY '$dbpass';FLUSH PRIVILEGES;"
	mysql -u $mysqluser -p $mysqlpass -e "$dbsetup"
		if [ $? != "0" ]; then
			echo "************************"
			echo "[Error]: Database creation failed. Aborting. :-("
			echo "------------------------"
			exit 1
		fi
fi

#login to MySQL, add db, add user and grant permissions to db
dbsetup="create database $dbname;GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@$mysqlhost IDENTIFIED BY '$dbpass';FLUSH PRIVILEGES;"
mysql -u $mysqluser -p$mysqlpass -e "$dbsetup"

#autop=$(echo $p | cut -c1-8);

#echo $autop

#echo $autop
#echo "password:" $PASSWDDB
#dbname="$autop"_"$DBNAME"
#echo $dbname

#mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'localhost';"

#echo "DB privleges granted"

# Credit to Daniel K for helping with this one, the old way used grep and cut then sed
# DBNAME="test"; sed -nr "s/define\(([\"'])DB_NAME\1,\s*([\"']).*\2/define(\1DB_NAME\1, \2${DBNAME}\2/gp" wp-config.php 
#define('DB_NAME', 'test');
#
sed -r \
    "
        s/define\(([\"'])DB_(NAME|USER)\1,\s*([\"']).*\2/define(\1DB_NAME\1, \2${DBNAME}\2/g;
        s/define\(([\"'])DB_PASSWORD\1,\s*([\"']).*\2/define(\1DB_NAME\1, \2${PASSWDDB}\2/g;
        s/define\(([\"'])DB_HOST\1,\s*([\"']).*\2/define(\1DB_NAME\1, \2localhost\2/g;
    " \
    -i wp-config.php

#chown -R $p:$p .

#chown $p:nobody /home/$p/public_html
