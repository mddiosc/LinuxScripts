export DIRBASE=$PWD
echo $DIRBASE
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
#
##########################################################################################

function obtenerDatosDominio() {
    ##########################################################################################
    # Esta funcion obtiene los datos del dominio SSL a configurar en Apache.
    ##########################################################################################
    #
    clear
    echo "Por favor introduzca los datos que se solicitan a continuación"
    echo "Serán utilizados para generar el nuevo dominio en apache"
    echo 
    echo 
    read -p "Nombre de Dominio: "  nombreDominio
    read -p "Email del administrador: " adminEmail
}

function preparaPlantilla(){
    ##########################################################################################
    # Esta función prepara el fichero de configuracion del dominio SSL que será configurado en apache.
    ##########################################################################################
    #
    # Copiamos la plantilla base que sera editada e instalada en apache.
    cat PLT/default-ssl.conf | grep -v "#" > $DIRBASE/CONF/${nombreDominio}-SSL.conf

    # Configuramos el mail del Administrador del dominio de Apache
    sed -i "s/ServerAdmin.*/ServerAdmin ${adminEmail}/g" $DIRBASE/CONF/${nombreDominio}-SSL.conf

    # Configuramos el directorio de logs de apache (acceso y errores)
    sed -i "s=ErrorLog.*=ErrorLog /var/log/apache2/${nombreDominio}/SSL-error.log=g" $DIRBASE/CONF/${nombreDominio}-SSL.conf
    sed -i "s=CustomLog.*=CustomLog /var/log/apache2/${nombreDominio}/SSL-access.log combined=g" $DIRBASE/CONF/${nombreDominio}-SSL.conf

    # Configuramos el directorio raiz (DocumentRoot) en la plantilla.
    sed -i "s=DocumentRoot.*=DocumentRoot /var/www/${nombreDominio}=g" $DIRBASE/CONF/${nombreDominio}-SSL.conf

    # Configuramos las rutas de acceso al certfiicado y a la clave primaria del dominio.
    sed -i "s=SSLCertificateFile.*=SSLCertificateFile	/etc/ssl/certs/${nombreDominio}.crt=g" $DIRBASE/CONF/${nombreDominio}-SSL.conf
    sed -i "s=SSLCertificateKeyFile.*=SSLCertificateKeyFile	/etc/ssl/private/${nombreDominio}.key=g" $DIRBASE/CONF/${nombreDominio}-SSL.conf
}

function prepararEntorno(){
    ##########################################################################################
    # Esta funcion realiza la configuración previa de apache para la activación del modulo SSL
    ##########################################################################################
    #
    
    # Copiamos la clave privada y el certificado a sus ubicaciones correspondientes en
    # el directorio /etc/ssl
    sudo cp ${DIRBASE}/../Certs/KEY/${nombreDominio}.key /etc/ssl/private/
    sudo cp ${DIRBASE}/../Certs/CERT/${nombreDominio}.crt /etc/ssl/certs

    # Habilitamos el soporte SSL en apache en caso de que no este habilitado.
    sudo a2query -m ssl > /devl/null 2> /dev/null
    if [ $? <> 0 ] 
    then
        a2enmod ssl
    fi
}
function  activaDominio(){
    # Copiamos el fichero de configuracion generado al directorio de sitios habilitados de apache (sites enabled)
    sudo cp $DIRBASE/CONF/${nombreDominio}-SSL.conf /etc/apache2/sites-available
    a2ensite ${nombreDominio}-SSL

    # Reiniciamos Apache
    sudo systemctl restart apache2

    # Informamos al usuario del resultado del proceso.
    echo "Se ha configurado el dominio seguro "${nombreDominio}
    echo "Puede validar su dominio conectandose a https://"${nombreDominio}
}
obtenerDatosDominio
preparaPlantilla
prepararEntorno
activaDominio
