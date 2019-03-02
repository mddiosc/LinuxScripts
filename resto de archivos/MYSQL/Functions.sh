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
        sudo mysql -u root <<show_users
            $query
show_users
    fi
    #select para usuarios y hosts
    if [ "$1" == "UserHost" ]
    then
        local query="SELECT User, Host FROM mysql.user;"
        sudo mysql -u root <<show_users
            $query
show_users
    fi
}

show_databases() {
    local query="show databases;"
    sudo mysql -u root <<show_db
        $query
show_db
}

#FUNCIONES PARA CREAR
crear_usuario() {
    local times=1
    while [ $times -le $1 ]
        do
            read -p "Escriba nombre del usuario nuevo: " new_user
            read -p "Escriba la contraseña del usuario: " new_pass
            read -p "Escriba la base de datos que quiere asignarle (deje en blanco si no quiere asignar): " new_db
            if [ -z "$new_db" ]
            then
                local query="CREATE USER $new_user IDENTIFIED BY '$new_pass';"
                sudo mysql -u root <<crear_usuario
                    $query
crear_usuario
            else
                local query="CREATE USER '$new_user'@'$new_db' IDENTIFIED BY '$new_pass';"
                sudo mysql -u root <<crear_usuario
                    $query
crear_usuario
            fi
            
            let "times++"
        done
}

crear_usuario_db() {
    echo "Crear usuario con db"
}

#FUNCIONES PARA BORRAR
borrar_usuario() {
    if [ -z "$2" ]
    then
        local query="DROP USER '$1';"
        sudo mysql -u root <<borrar_usuario
            $query
borrar_usuario
    else
        local query="DROP USER '$1'@'$2';"
        sudo mysql -u root <<borrar_usuario
            $query
borrar_usuario
    fi
}

borrar_db() {
    local query="drop database '$1';"
    sudo mysql -u root <<borrar_db
        $query
borrar_db
}