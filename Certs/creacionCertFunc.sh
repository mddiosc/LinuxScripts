#########################################################################################
#
# Creacion de un CSR a partir de una plantilla con los datos introducidos por el usuario
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
    # Esta funcion obtiene los datos del certificado a emitir
    ##########################################################################################
    # Establecer el pais por defecto en ES (España), y solicita los datos necesarios 
    # para el certificado.
    #
    pais="ES"
    read -e -p "`i18n_muestra pais` [ES]: " -i "ES" pais
    read -p "`i18n_muestra estado`: " estado
    read -p "`i18n_muestra ciudad`: " ciudad
    read -p "`i18n_muestra org`: " organizacion
    read -p "`i18n_muestra dominio`: " fqdn
    read -p "`i18n_muestra mail`: " email
}

function preparaCSRConf (){
    cp $MIBASEDIR/PLT/csr.cnf $MIBASEDIR/CNF/$fqdn.csr.cnf
    ##########################################################################################
    # Preparación del fichero de configuracion que será utilizado para generar el CSR
    ##########################################################################################

    # Realizamos la copia de la plantilla en el directorio CNF donde procederemos a modificarla
    

    # Modificación de la plantilla personalizandola para el CSR
    # Las sustituciones se llevan a cabo en todo el fichero.
    # Se utilizan comillas dobles en el comando sed para que se lleve a cabo la sustitucion 
    # de variables.
    
    # Sustituimos el FQDN de la plantilla (DOMINIO), por el FQDN especificado por el usuario
    sed -i "s/DOMINIO/${fqdn}/g" $MIBASEDIR/CNF/$fqdn.csr.cnf

    # Sustituimos el pais de la plantilla (PAIS), por el pais especificado por el usuario
    sed -i "s/PAIS/${pais}/g" $MIBASEDIR/CNF/$fqdn.csr.cnf

    # Sustituimos el estado (Comunidad Autonoma) de la plantilla (ESTADO), por la organización especificado por el usuario
    sed -i "s/ESTADO/${estado}/g" $MIBASEDIR/CNF/$fqdn.csr.cnf

    # Sustituimos el la ciudad de la plantilla (CIUDAD), por la ciudad especificado por el usuario
    sed -i "s/CIUDAD/${ciudad}/g" $MIBASEDIR/CNF/$fqdn.csr.cnf

    # Sustituimos la organizacion de la plantilla (ORGANIZACION), por la organización especificado por el usuario
    sed -i "s/ORGANIZACION/${organizacion}/g" $MIBASEDIR/CNF/$fqdn.csr.cnf

    # Sustituimos el mail de contacto  de la plantilla (EMAIL), por el email  especificado por el usuario
    sed -i "s/EMAIL/${email}/g" $MIBASEDIR/CNF/$fqdn.csr.cnf
}

function generaKey_CSR(){
    ##########################################################################################
    # Generación de la clave privada y del CSR.
    ##########################################################################################

    # Utilizando el comando openssl para generar la key y el CSR
   openssl req -new -config $MIBASEDIR/CNF/${fqdn}.csr.cnf -keyout $MIBASEDIR/KEY/${fqdn}.key -out $MIBASEDIR/CSR/${fqdn}.csr

    # Protegemos la key cambiando los permisos de forma que solo quien lo genera pueda acceder o modificarla
    chmod 0600 $MIBASEDIR/KEY/${fqdn}.key
}

function generarCertificado(){
    # Generación del certificado autofirmado a partir de la clave privada y el CSR previamente generados.
    openssl x509 -req -days 365 -in ${MIBASEDIR}/CSR/${fqdn}.csr -signkey ${MIBASEDIR}/KEY/${fqdn}.key -out ${MIBASEDIR}/CERT/${fqdn}.crt
}
