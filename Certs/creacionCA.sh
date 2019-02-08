export DIRBASE=$PWD
echo $DIRBASE
#########################################################################################
#
# Creacion de una CA a partir de una plantilla con los datos introducidos por el usuario
#
# Autor: Miguel Ángel de Dios 
#
# Variables:
#           pais: Pais donde se localiza la empresa
#           estado: Estado o comunidad autónoma donde se localiza la empresa
#           ciudad : Ciudad donde se localiza la empresa
#           organizacion : Nombre de la empresa
#           fqdn: Nombre completo del dominio para el que se generará el certifiado
#           email: Correo electrónico de contacto del responsable del dominio.
#
##########################################################################################

function obtenerdatos() {
    ##########################################################################################
    # Esta funcion obtiene los datos del certificado de CA a emitir
    ##########################################################################################
    # Establecer el pais por defecto en ES (España), y solicita los datos necesarios 
    # para el certificado.
    #
    pais="ES"
    read -e -p "País [ES]: " -i "ES" pais
    read -p "Estado: " estado
    read -p "Ciudad: " ciudad
    read -p "Organización: " organizacion
    read -p "Nombre de dominio : " fqdn
    read -p "Direccion email: " email
}
