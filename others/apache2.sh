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
# Archivo: apache2.sh


# Instalacion de las herramientas necesarias para la creacion
# de un servidor apache2.

sudo apt-get install ufw
sudo apt-get install apache2
sudo apt-get install -y openssh-server

# Activamos el Firewall instalado anteriormente.

sudo ufw enable

# Creamos los directorios donde vamos a tener los archivos de
# nuestro servidor web.
# Usando la opción -p de tal manera que se creen los 
# directorios padres necesarios.

sudo mkdir -p /var/www/ejemplo.com/html

# Asigna el usuario propietario del directorio, 
# mediante la variable de entorno $USER:

sudo chown -R $USER:$USER /var/www/ejemplo.com/html

# Los permisos de tus directorios raíz para la web no se 
# modifican a menos que cambies el valor de unmask. 
# Sin embargo podemos usar el siguiente comando:

sudo chown -R 755 /var/www/ejemplo.com/html

#

sudo echo -e "<html> \n <head> \n <meta charset='UTF-8'> \n <title>¡Bienvenido a Ejemplo.com&#33;</title> \n </head> \n <body> \n <h1>¡El proceso ha sido exitoso&#33; ¡El bloque de servidor ejemplo.com se encuentra en funcionamiento&#33;</h1> \n </body> \n </html>" > /var/www/ejemplo.com/html/index.html

sudo echo -e "<VirtualHost *:80> \n ServerAdmin admin@ejemplo.com \n ServerName ejemplo.com \n ServerAlias www.ejemplo.com \n DocumentRoot /var/www/ejemplo.com/html \n ErrorLog ${APACHE_LOG_DIR}/error.log \n CustomLog ${APACHE_LOG_DIR}/access.log combined \n </VirtualHost>" > /etc/apache2/sites-available/ejemplo.com.conf

sudo systemctl reload apache2

sudo a2ensite ejemplo.com.conf

sudo systemctl reload apache2

sudo a2dissite 000-default.conf

sudo systemctl restart apache2

sh ./mysql-server.sh