export DIRBASE=$PWD
#echo $DIRBASE
##############################################################################################################################################
#
# Listado de certificados generados
#
# Autor: Miguel Ángel de Dios 
#
# Variables:
#           certificados : Lista de los certificados emitidos obtenida a partir de un ls en el directorio CERT
#           certificado : Variable de control del bucle for
#           fichero : Nombre de fichero (obtenida a partir de la variable certificado) - REDUNDANTE -
#           dominio: Nombre del dominio obtenido a partir del certificado mediante el comando openssl X509
#           desde: Fecha a partir de la cual es válido el certificado. Obtenida a partir del certificado mediante el comando openssl
#           expiracion: Fecha de expiración del dominio obtenida a partir del certificado mediante el comando openssl        
#
# Instruccion openssl x509 -in FICHEROCERTIFICADO -text -noout 
#                       -in: Fichero a examinar
#                       -text: Desplegar la salida en texto legible
#                       -noout: No generar ningun fichero de salida. Se muestra por la salida estandard (STDIN) 
##############################################################################################################################################

# Se obtiene una lista (ls) de los ficheros que se encuentran en la carpeta CERT (donde se almacenan los certificados)
# Se desvía la salida del comando ls para que redirija los errores a /dev/null y que no aparezcan en la consola
certificados=`ls $DIRBASE/CERT/*.crt 2> /dev/null`
# Se valida el estado devuelto por el ultimo comando (ls). Si es diferente de 0, indicará que no se ha encontrado ningun
# fichero. Si es igual a 0 se obtendra la inforamación de cada certificado, almacenandola en las variables
if [ $? -eq 0 ]
# Si se encuentran ficheros de certificado
    then
    for certificado in ${certificados}
    do
        fichero=${certificado}
        dominio=`openssl x509 -in $certificado -text -noout | grep Subject | grep CN | cut -d"," -f 3 | cut -d"=" -f 2`
        desde=`openssl x509 -in $certificado -text -noout | grep Before | cut -d":" -f 2,3,4`
        expiracion=`openssl x509 -in $certificado -text -noout | grep After | cut -d":" -f 2,3,4`
        echo "========================================================================================================="
        echo "Fichero: "$fichero
        echo "_________________________________________________________________________________________________________"      
        echo "Dominio: "$dominio
        echo "Válido desde: "$desde
        echo "Válido hasta: "$expiracion
        echo "========================================================================================================="
        echo " "
        echo " "
    done
else
# Si no se encuentran ficheros de certificado.
    echo "No se encontraron certificados emitidos en la carpeta CERT"
fi