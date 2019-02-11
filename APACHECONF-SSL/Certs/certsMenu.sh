#!/bin/bash
# Establecemos el directorio donde se almacenara la informacion referente a certificados.
BASE_DIR=$PWD
verde="\e[0;32m"
sincolor="\e[0m"
azul="\e[0;34m"
rojo="\e[0;31m"
amarillo="\e[0;33m"

function creaCSR {
    PS3=''
    clear
    echo "*******************************************************************************"
    echo "GENERACION DE UNA PETICION DE FIRMA DE CERTIFICADO (CSR)"
    echo "*******************************************************************************"
    echo 
    echo por favor introduzca los datos solicitados
    exit 1
    }
function creaCA {
    echo "Hola! vas a generar una nueva CA"
    }
function creaCert {
    echo "Hola! vas a generar un nuevo Certificado"
    }     
clear
echo -e ${green}"--------------------------------------------------------------------------------------"${sincolor}
PS3='Elija una Opción: '
opciones=("Solicitud de Certificado (CSR)" "Configurar CA" "Emitir Certificado Autofirmado" "Salir")
echo ${opciones[@]}
select opcion in "${opciones[@]}"
do
    case $opcion in
        "Solicitud de Certificado (CSR)")
            echo "Solicitud de Certificado (CSR)"
            creaCSR
            ;;
        "Configurar CA")
            echo "Configurar CA"
            creaCA
            ;;
        "Emitir Certificado Autofirmado")
            echo "Emitir Certificado Autofirmado"
            creaCert
            ;;
        "Salir")
            break
            ;;
        *) echo "*** Error *** Opción inválida $REPLY";;
    esac
done

function creaCSR {
    echo "Hola! vas a generar un CSR"
    }
