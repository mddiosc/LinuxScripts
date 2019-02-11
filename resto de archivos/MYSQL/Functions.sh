#!/usr/bin/env bash
# Copyright (C) 2018 - 2019 Miquel Angel Riera Ferra
# 
# Este archivo es parte de la instalación y configuración de un servidor LAMP.
#
# System Required: Ubuntu 14+
# Description: Funciones del Menú de gestión de usuarios y bases de datos.
# Github:   https://github.com/maded79/LinuxServidorWeb
# Archivo: Functions.sh

#FUNCION PAUSE
pause() {
    read -n1 -r -p "Pulse ENTER para continuar..."
}

#FUNCION ERROR COMANDO
checkerror() {
    if [ $? -eq 0 ]
    then
        echo "Ejecución correcta"
    else
        echo "Hubo algún fallo en la ejecución"
    fi
}

#FUNCIONES VISUALIZAR
show_users() {
    #select solo para usuarios
    if [ "$1" == "User" ]
    then
        local query="SELECT User FROM mysql.user;"
        sudo mysql -u root -p <<show_users
        $query
show_users
    fi
    #select para usuarios y hosts
    if [ "$1" == "UserHost" ]
    then
        local query="SELECT User, Host FROM mysql.user;"
        sudo mysql -u root -p <<show_users
        $query
show_users
    fi
}

#FUNCIONES PARA CREAR
crear_usuario() {
local times=1
while [ $times -le $1 ]
    do
        read -p "Escriba nombre del usuario nuevo: " new_user
        read -p "Escriba la contraseña del usuario: " new_pass
        local query="CREATE USER $new_user IDENTIFIED BY '$new_pass';"
        sudo mysql -u root -p <<crear_usuario
        $query
crear_usuario
        let "times++"
    done
}

#FUNCIONES PARA BORRAR
borrar_usuario() {
    if [ -z "$2" ]
    then
        local query="DROP USER '$1';"
        sudo mysql -u root -p <<borrar_usuario
        $query
borrar_usuario
    else
        local query="DROP USER '$1'@'$2';"
        sudo mysql -u root -p <<borrar_usuario
        $query
borrar_usuario
    fi
}