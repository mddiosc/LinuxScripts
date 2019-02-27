export MIBASEDIR=$BASEDIR/Certs
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
certificados=`ls $MIBASEDIR/CERT/*.crt 2> /dev/null`

# Se valida el estado devuelto por el ultimo comando (ls). Si es diferente de 0, indicará que no se ha encontrado ningun
# fichero. Si es igual a 0 se obtendra la inforamación de cada certificado, almacenandola en las variables
if [ $? -eq 0 ]
# Si se encuentran ficheros de certificado
    then
    # Para cada nombre encontrado por ls
    for certificado in ${certificados}
    do
        fichero=${certificado}
        # Utilizamos el comando openssl para obtener la información del certificado.
        
        # Obtenemos la línea de subject.
        # La linea de Subject contiene por ejemplo:
        #Subject: C = ES, O = Test 1, CN = www.test1.com, emailAddress = mail@test1.com, L = Palma de Mallorca, ST = Baleares
        # con cut obtenemos el 3er campo delimitado por comas,(CN = www.test1.com) y luego lo pasamos por cut de nuevo para obtener
        # el segundo campo delimitado por '=' (www.test.com)
        dominio=`openssl x509 -in ${certificado} -text -noout | grep Subject | grep CN | cut -d"," -f 3 | cut -d"=" -f 2`
        
        #Procedemos igual que con el dominio, utilizando el 4 campo correspondiente al email.
        email=`openssl x509 -in ${certificado} -text -noout | grep Subject | grep CN | cut -d"," -f 4 | cut -d"=" -f 2`
        
        # Obtenemos la fecha de inicio de la validez del certificado
        desde=`openssl x509 -in ${certificado} -text -noout | grep Before | cut -d":" -f 2,3,4`
        
        # Obtenemos la fecha de fin de la validez del certificado
        expiracion=`openssl x509 -in ${certificado} -text -noout | grep After | cut -d":" -f 2,3,4`

        # Imprimimos la informacion relativa al certificado
        printf "=========================================================================================================\n"
        printf "Fichero: ${fichero}\n"
        printf "_________________________________________________________________________________________________________\n"   
        printf "`i18n_muestra dominio` ${ROJO}${dominio}${NC}\n"
        printf "`i18n_muestra mail` ${email}\n"
        printf "`i18n_muestra desde` ${desde}\n"
        printf "`i18n_muestra hasta` ${expiracion}\n"
        printf "=========================================================================================================\n"
        echo " "
        echo " "
    done
else
# Si no se encuentran ficheros de certificado.
    echo "`i18n_muestra noencontrado`"
fi

echo `i18n_muestra presionartecla`
read -n1 -s