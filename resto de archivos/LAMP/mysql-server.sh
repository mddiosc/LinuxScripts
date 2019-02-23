#!/bin/bash
# Copyright (C) 2018 - 2019 Lmartin
# 
# Este archivo es parte de la instalación y configuración 
# de un servidor LAMP.
#
# System Required: Ubuntu 14+
# Description:  Instalación y configuración LAMP
# (Linux + Apache + MySQL/MariaDB + PHP )
# Github:   https://github.com/maded79/LinuxServidorWeb
# Archivo: mysql-server.sh

sudo apt install mysql-server



sudo mysql_secure_installation
