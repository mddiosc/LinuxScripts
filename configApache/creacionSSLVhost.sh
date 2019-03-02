export TEXTDOMAIN=apacheconf
export MIBASEDIR=$BASEDIR/configApache
error=0
#########################################################################################
#
# Configuracion de un host virtual SSL de apache2 server  a partir de una plantilla 
# con los datos introducidos por el usuario
# Para crear el sitio SSL se debe haber configurado previamente el sitio HTTP
#
# Autor: Miguel Ángel de Dios 
#
# Variables:
#           nombreDominio: Nombre del Dominio que será configurado.
#           adminEmail: Dirección de e-mail del responsable del dominio
# Comandos Utilizados:
#           echo - Despliega una línea de textl
#           read - lee una linea desde stdin y la asigna a la variable especificada.
#               Sintaxis utilizada: read -p "prompt" NAME
#               -p Despliega el prompt indicado por la cadena entre comillas
#               NAME : Nombre de variable que almacenara la entrada del usuario.  
#           cat - concatena ficheros y despliega en la salida estándar. En este caso lo utilizamos
#               para redirigir el contenido de un fichero hacia otro utilizando la redireccion >
#               Sintaxis utilizada : cat FICHERO
#           grep - Imprime lineas que cumplan o no un patron según lo especificado por el modificador
#               Sintaxis utilizada : grep -v VALOR
#               selecciona todas las lineas proporcionadas por CAT excepto aquellas que contengan VALOR
#           sed - Editor en linea (stream) para filtrar y transformar texto. Utilizado para realizar
#               transformaciones de texto básicas a partir de una entrada.
#               Sintaxis utilizada: sed -i "s<DELIMITADOR>Cadena a sustituir (RegEX)<DELIMITADOR> Nu"      
#
##########################################################################################

function obtenerDatosDominio() {
    ##########################################################################################
    # Esta funcion obtiene los datos del dominio SSL a configurar en Apache.
    ##########################################################################################
    #
    clear
    printf "${VERDE}***************************************************************************************${NC}\n"
    printf "${VERDE} `i18n_muestra tituloVhost` - SSL${NC}\n"
    printf "${VERDE} `i18n_muestra mensajessl`${NC}\n"
    printf "${VERDE}***************************************************************************************${NC}\n\n"
    echo `i18n_muestra datosdom1`
    echo `i18n_muestra datosdom2`
    echo 
    echo 
    nombreDominio=`i18n_lee domainname`
    adminEmail=`i18n_lee adminmail`
    registro "ApacheVirtualHostSSL" "Se han obtenido correctamente los datos para el dominio ${nombreDominio}"
}

function preparaPlantilla(){
    ##########################################################################################
    # Esta función prepara el fichero de configuracion del dominio SSL que será configurado en apache.
    ##########################################################################################
    #
    # Copiamos la plantilla base que sera editada e instalada en apache.
    cat $MIBASEDIR/PLT/default-ssl.conf | grep -v "#" > $MIBASEDIR/CONF/${nombreDominio}-SSL.conf

    # Configuramos el mail del Administrador del dominio de Apache
    sed -i "s/ServerAdmin.*/ServerAdmin ${adminEmail}/g" $MIBASEDIR/CONF/${nombreDominio}-SSL.conf

    # Configuramos el directorio de logs de apache (acceso y errores)
    sed -i "s=ErrorLog.*=ErrorLog /var/log/apache2/${nombreDominio}/SSL-error.log=g" $MIBASEDIR/CONF/${nombreDominio}-SSL.conf
    sed -i "s=CustomLog.*=CustomLog /var/log/apache2/${nombreDominio}/SSL-access.log combined=g" $MIBASEDIR/CONF/${nombreDominio}-SSL.conf

    # Configuramos el directorio raiz (DocumentRoot) en la plantilla.
    sed -i "s=DocumentRoot.*=DocumentRoot /var/www/${nombreDominio}=g" $MIBASEDIR/CONF/${nombreDominio}-SSL.conf

    # Configuramos las rutas de acceso al certfiicado y a la clave primaria del dominio.
    sed -i "s=SSLCertificateFile.*=SSLCertificateFile	/etc/ssl/certs/${nombreDominio}.crt=g" $MIBASEDIR/CONF/${nombreDominio}-SSL.conf
    sed -i "s=SSLCertificateKeyFile.*=SSLCertificateKeyFile	/etc/ssl/private/${nombreDominio}.key=g" $MIBASEDIR/CONF/${nombreDominio}-SSL.conf
    registro "ApacheVirtualHostSSL" "Se ha preparado la configuracion para el dominio ${nombredominio} correctamente"
}

function configurarSSL(){
    ##########################################################################################
    # Esta funcion realiza la configuración previa de apache para la activación del modulo SSL
    ##########################################################################################
    #
    
    # Copiamos la clave privada y el certificado a sus ubicaciones correspondientes en
    # el directorio /etc/ssl
    if [ -f ${MIBASEDIR}/../Certs/KEY/${nombreDominio}.key ]
    then
        sudo cp ${MIBASEDIR}/../Certs/KEY/${nombreDominio}.key /etc/ssl/private/
        sudo cp ${MIBASEDIR}/../Certs/CERT/${nombreDominio}.crt /etc/ssl/certs

        # Habilitamos el soporte SSL en apache en caso de que no este habilitado.
        sudo a2query -m ssl > /dev/null 2> /dev/null
        if [ $? <> 0 ] 
        then
            sudo a2enmod ssl > /dev/null 2> /dev/null
        fi
        registro "ApacheVirtualHostSSL" "Se han copiado los ficheros de certificado para el dominio ${nombredominio} correctamente"
    else
        printf "${ROJO}`i18n_muestra errnocert`${NC}"
        error=1
        registro "ApacheVirtualHostSSL" "No se han encontrado los ficheros de certificado para el dominio ${nombredominio}"
    fi
}
function  activaDominio(){
    # Copiamos el fichero de configuracion generado al directorio de sitios habilitados de apache (sites enabled)
    sudo cp $MIBASEDIR/CONF/${nombreDominio}-SSL.conf /etc/apache2/sites-available
    sudo a2ensite ${nombreDominio}-SSL > /dev/null 2> /dev/null

    # Reiniciamos Apache
    sudo systemctl restart apache2 > /dev/null 2> /dev/null

    # Informamos al usuario del resultado del proceso.
    printf "`i18n_muestra dominioconfigurado`: ${VERDE}${nombreDominio}${NC}\n"
    printf "`i18n_muestra validadominio`${VERDE} https://${nombreDominio}${NC}\n"
}
obtenerDatosDominio
configurarSSL
if [ ${error} -ne 1 ]
then
    preparaPlantilla
    activaDominio
    registro "ApacheVirtualHostSSL" "Configuración de apache completa para el dominio seguro ${nombreDominio} (https://${nombreDominio})"
else
    printf "${ROJO}`i18n_muestra error`${NC}"
    registro "ApacheVirtualHostSSL" "ERROR: No ha sido posible configurar el dominio SSL ${nombredominio}"
fi

export TEXTDOMAIN=principal
echo
echo `i18n_muestra presionartecla`
read -n1 -s
