#!/usr/bin/env bash
# Copyright (C) 2018 - 2019 Lmartin
# 
# Este archivo es parte de la instalación y configuración 
# de un servidor LAMP.
#
# System Required: Ubuntu 14+
# Description:  Instalación y configuración LAMP
# (Linux + Apache + MySQL/MariaDB + PHP )
# Github:   https://github.com/maded79/LinuxServidorWeb
# Archivo: php.sh


sudo apt install php libapache2-mod-php php-mysql

sudo echo -e "<IfModule mod_dir.c> \n DirectoryIndex index.php index.cgi index.pl index.html index.xhtml inde$ \n </IfModule> \n # vim: syntax=apache ts=4 sw=4 sts=4 sr noet" > /etc/apache2/mods-enabled/dir.conf

sudo systemctl restart apache2

sudo echo -e "<?php \n phpinfo(); \n ?>" > /var/www/html/info.php

sudo apt-get install php-mbstring php-gettext

sudo phpenmod mcrypt
sudo phpenmod mbstring

sudo systemctl restart apache2

echo -e ""

echo -e "AuthType Basic \n AuthName 'Restricted Files' \n AuthUserFile /etc/phpmyadmin/.htpasswd \n Require valid-user" > /usr/share/phpmyadmin/.htaccess

sudo apt-get install apache2-utils

sudo htpasswd -c /etc/phpmyadmin/.htpasswd username

sudo htpasswd /etc/phpmyadmin/.htpasswd additionaluser


