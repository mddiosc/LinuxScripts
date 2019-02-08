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
##############################################################################################


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
    read -p "Organización: " fqdn
    read -p "Direccion email: " email
}

function generarCAKey(){
    ##########################################################################################
    # Fase 1 de la generacion de la CA. Generación de la clave privada (private key) de la CA
    ########################################################################################## 
    
    # Generamos una contraseña segura para la key y la almacenamos en un fichero,:
    openssl rand -base64 32 > $DIRBASE/CA/${fqdn}pass.txt
    chmod 0700 $DIRBASE/CA/${fqdn}pass.txt

    #Generacion de la clave privada, encriptada mediante aea256 para securizarla al maximo con el mejor rendimiento
    openssl genrsa -aes256 -passout file:$DIRBASE/CA/${fqdn}pass.txt -out $DIRBASE/CA/${fqdn}CA.key.pem
}

generarCAKey