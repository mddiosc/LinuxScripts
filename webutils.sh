#! /usr/bin/env bash
#
# Guia de Bash Avanzado http://www.tldp.org/LDP/abs/html/
#########################################################################################
#
# Script de entrada a la aplicación de gestion de herramientas web
# Script: webutils.sh
#
# Autor: Miguel Ángel de Dios 
#
# Variables:
#           lenguaje : Utilizada para desplegar el idioma seleccionado por el usuario
#           opcion: Variable que controla la opción que ha seleccionado el usuario
#
##########################################################################################

# Llamada al script que prepara el entorno de usuario para la ejecución de la herramienta.
source preparaEntorno.sh
lenguaje=`echo ${LANGUAGE} | cut -d"_" -f 1 | tr a-z A-Z`
registro "menu" "Acceso al Menu Principal." 
while true 
do
clear
printf "${ROJO}${lenguaje}${NC}"
echo
echo `i18n_muestra menup`
printf "${VERDE}`i18n_muestra instalacion`${NC}"
echo 
echo "1.- Apache Web Server"
echo "2.- MySQL"
echo "3.- PHP"
echo
printf "${VERDE}`i18n_muestra confmysql`${NC}"
echo 
echo "4.- `i18n_muestra dbcrear`"
echo "5.- `i18n_muestra dbusrcrear`"
echo
printf "${VERDE}`i18n_muestra vhosts`${NC}"
echo 
echo "6.- `i18n_muestra gencert`"
echo "7.- `i18n_muestra listacerts`"
echo "8.- `i18n_muestra vhostconf` (No-SSL)"
echo "9.- `i18n_muestra vhostconf` (SSL)"
echo
printf "${ROJO}10. `i18n_muestra salir`${NC}"
echo 
opcion=`i18n_lee menuopt`
case ${opcion} in
    1)
        echo "Instalar Apache"
        sleep 3
        ;;
    2)
        echo "Instalar MySQL"
        sleep 3
        ;;
    3)
        echo "Instalar PHP"
        sleep 3
        ;;
    4)
        echo "Crear Base de datos"
        sleep 3
        ;;
    5)
        echo "Crear usuario base de datos"
        sleep 3
        ;;
    6) 
        source $BASEDIR/Certs/creacionCertificado.sh
        sleep 3
        ;;
    7) 
        source $BASEDIR/Certs/listarCertificados.sh
        ;;       
    8)
        echo "Configurar Virtual Host"
        sleep 3
        ;;
    9) 
        echo "Configurar Virtual Host SSL"
        sleep 3
        ;;
    10)
        echo "Gracias por utilizar la aplicacion"
        sleep 3
        break
        ;;
esac
done




