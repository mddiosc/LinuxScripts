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
# Archivo: preinstall.sh

source ./LAMP/function.sh
inicio_programa

sudo apt update
_log "sudo apt update"
sudo apt upgrade -y
_log "sudo apt upgrade -y"
sudo apt-get install ubuntu-restricted-extras -y
_log "sudo apt-get install ubuntu-restricted-extras -y"
sudo apt-get install expect -y
_log "sudo apt-get install expect -y"

source ./LAMP/apache2.sh
