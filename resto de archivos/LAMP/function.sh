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
# Archivo: function.sh

function HORA(){
    date +%H:%M:%S
}

function FECHA(){
    date +%x
}

function añadir_fecha(){
    echo -e "Iniciado: `FECHA` `HORA`" >> REGISTRO/registro.txt
}

function is_error(){
    error=
    if [[ $1 -eq 0 ]]
    then
        error=False
    else
        error=True
    fi
}

app=LAMP
function _reg(){
    if [[ $error -eq False ]]
    then
        echo $* "ha funcionado correctamente." >> REGISTRO/registro.txt
    else
        echo $* "ha habido alun problema." >> REGISTRO/registro.txt
    fi
}

function _log(){
    is_error $?; añadir_fecha; _reg $*;
}



function listo(){
    ins=$(dpkg -s $1 | grep Status)
    unset opc
    if [[ $ins != "Status: install ok installed" ]]
    then
        opc=True
    else
        opc=False
    fi
}