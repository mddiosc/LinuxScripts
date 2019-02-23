export DIRBASE=$PWD
echo $DIRBASE
#########################################################################################
#
# Creacion de un Certificado Seguro a partir de una key y un CSR previamente creado
#
# Autor: Miguel Ángel de Dios 
#
# Variables:
#           fqdn: Nombre completo del dominio para el que se generará el certifiado
#
##########################################################################################

function obtenerdatos() {
    ##########################################################################################
    # Esta funcion obtiene el nombre del certificado a emitir.
    ##########################################################################################

    echo "Indique el nombre de dominio para el que se generará el certificado"
    echo "La clave privada y el CSR deben haber sido generados previamente"
    read -p "Nombre de dominio : " fqdn
}

function generarCertificado(){
    # Generación del certificado autofirmado a partir de la clave privada y el CSR previamente generados.
    openssl x509 -req -days 365 -in ${DIRBASE}/CSR/${fqdn}.csr -signkey ${DIRBASE}/KEY/${fqdn}.key -out ${DIRBASE}/CERT/${fqdn}.crt
}

obtenerdatos
generarCertificado