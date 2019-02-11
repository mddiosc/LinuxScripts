#!/usr/bin/env bash
# Copyright (C) 2018 - 2019 Miquel Angel Riera Ferra
# 
# Este archivo es parte de la instalación y configuración de un servidor LAMP.
#
# System Required: Ubuntu 14+
# Description: Menú de gestión de usuarios y bases de datos.
# Github:   https://github.com/maded79/LinuxServidorWeb
# Archivo: GestBDyU.sh
clear
. ./Functions.sh
echo Gestor de Bases de datos y Usuarios:
echo 1. Visualizar usuarios.
echo 2. Crear usuario.
echo 3. Modificar/Borrar usuario.
echo 4. Visualizar Bases de datos.
echo 5. Crear base de datos.
echo 6. Modificar/Borrar base de datos.
echo 7. Exit
read -p "Escriba el número de opción que desea: " opcion
#Opcion para visualizar usuarios 1
if [ $opcion -eq 1 ] 2> /dev/null
then
    show_users "UserHost"
    pause
fi
#Opcion para crear usuario 2
if [ $opcion -eq 2 ] 2> /dev/null
then
    echo "Actualmente hay estos usuarios:"
    show_users "User"
    read -p "Cuantos usuarios quiere crear?: " num_users
    if [ $num_users -ge 1 ] 2> /dev/null
    then
        crear_usuario $num_users 2> /dev/null
        checkerror
    else
        echo "No ha introducido un valor válido"
    fi
    pause
fi
#Opcion para modificar/borrar usuario 3
if [ $opcion -eq 3 ] 2> /dev/null
then
    echo "Actualmente hay estos usuarios:"
    show_users "User"
    read -p "Teclee 'b' para borrar o 'm' para modificar usuario: " opcion
    if [ "$opcion" == "b" ] 
    then
        read -p "Escriba el nombre del usuario a borrar (deje en blanco para salir): " nombre
        if [ "$nombre" != "" ]
        then
            read -p "Escriba el host del usuario (deje en blanco si no tiene): " host
            if [ "$host" != "" ]
            then
                borrar_usuario "$nombre" "$host" 2> /dev/null
                checkerror
            else
                borrar_usuario "$nombre" 2> /dev/null
                checkerror
            fi
        fi
    elif [ "$opcion" == "m" ]
    then
        echo "Opciones mods"
    else
        echo "No ha introducido un valor válido"
    fi
    pause
fi
#Opcion para salir 7
if [ $opcion -eq 7 ] 2> /dev/null
then
    clear
    exit 0
fi
./$0
