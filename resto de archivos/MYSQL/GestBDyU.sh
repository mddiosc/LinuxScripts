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
echo "5. Crear base de datos (plantilla)."
echo 6. Borrar base de datos.
echo 7. Exit
read -p "Escriba el número de opción que desea: " opcion
case $opcion in
    #Opcion para visualizar usuarios 1
    1)
        show_users "UserHost"
        pause
        ;;
    #Opcion para crear usuario 2
    2)
        echo "Actualmente hay estos usuarios:"
        show_users "User"
        read -p "Cuantos usuarios quiere crear?: " num_users
        if [ $num_users -ge 1 ] 2> /dev/null
        then
            crear_usuario "$num_users"
        else
            echo "No ha introducido un valor válido"
        fi
        pause
        ;;
    #Opcion para modificar/borrar usuario 3
    3)
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
                    borrar_usuario "$nombre" "$host"
                else
                    borrar_usuario "$nombre"
                fi
            fi
        elif [ "$opcion" == "m" ]
        then
            echo "Opciones mods"
        else
            echo "No ha introducido un valor válido"
        fi
        pause
        ;;
    #Opcion para ver bases de datos 4
    4)
        show_databases
        pause
        ;;
    #Opcion para borrar bases de datos 6
    6)
        show_databases
        read -p "Escriba el nombre de la base de datos que quiere borrar: " database
        borrar_db "$database"
        pause
        ;;
    #Opcion para salir 7
    7)
        clear
        exit 0
        ;;
    *)
        echo "No ha introducido ninguna opción válida."
        pause
        ;;
esac
./$0
