export TEXTDOMAIN=apacheconf
export MIBASEDIR=$BASEDIR/configApache
#########################################################################################
#
# Configuracion de un host virtual de apache2 server  a partir de una plantilla 
# con los datos introducidos por el usuario
#
# Autor: Miguel Ángel de Dios 
#
# Variables:
#           nombreDominio: Nombre del Dominio que será configurado.
#           adminEmail: Dirección de e-mail del responsable del dominio
#           usuario : Usuario que sera añadido al sistema operativo para gestionar el contenido.
#           contrasenya : Contraseña generada automáticamente que es asignada al usuario
#
# Comandos Utilizados:
#           echo - Despliega una línea de texto
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
#               Sintaxis utilizada: sed -i "s<DELIMITADOR>Cadena a sustituir (RegEX)<DELIMITADOR> Nueva cadena/g" NOMBREFICHERO
#                   -i - realiza las modificaciones en el mismo fichero NOMBREFICHERO
#                   <DELIMITADOR> Delimitador a utilizar para el comando sed. El deliimitador por defecto es /, pero es posible
#                               que sea necesario cambiarlo cuando alguna de las cadenas contiene el caracter "/"
#                               En los casos en los que ha sido necesario sustituirlo, se ha utilizado un "="  
#                   NOMBREFICHERO: fichero sobre el que se realizarán los cambios.  
#               Sintaxis utilizada: sed -i "ni <CADENA DE TEXTO>" NOMBREFICHERO
#                    -i - Realiza las modificaciones en el mismo fichero NOMBREFICHERO
#                    "ni" inserta una linea completa en la linea n
#                   <CADENA DE TEXTO> : Cadena de texto a insertar en la posicion especificada en el fichero NOMBREFICHERO.
#                
#           chpsswd : Utilizado para cambiar la contraseña del usuario.
#           openssl rand : Utilizado para generar una contraseña aleatoria de 8 caracteres que será asignada al usuario.
#           a2ensite : (comando de Apache 2). Permite habilitar un host virtual a partir de un fichero de configuracion
#                      copiado en el directorio /etc/apache2/sites-available
#           systemctl - Permite controlar el servicio apache. Utilizado para reiniciar apache tras el cambio de configuración.
#
##########################################################################################


function obtenerDatosDominio() {
    ##########################################################################################
    # Esta funcion obtiene los datos del dominio a configurar en Apache.
    ##########################################################################################
    #
    clear
    printf "${VERDE}***************************************************************************************${NC}\n"
    printf "${VERDE} `i18n_muestra tituloVhost`${NC}\n"
    printf "${VERDE}***************************************************************************************${NC}\n\n"
    echo `i18n_muestra datosdom1`
    echo `i18n_muestra datosdom2`
    echo 
    echo 
    nombreDominio=`i18n_lee domainname`
    adminEmail=`i18n_lee adminmail`
    usuario=`i18n_lee sftpusu`
    registro "ApacheVirtualHost" "Se han obtenido correctamente los datos para el dominio ${nombreDominio}"
}

function preparaPlantilla(){
    ##########################################################################################
    # Esta función prepara el fichero de configuracion del dominio que será instalado en apache.
    ##########################################################################################
    #
    # Copiamos la plantilla base que sera editada e instalada en apache.
    cat $MIBASEDIR/PLT/000-default.conf | grep -v "#" > $MIBASEDIR/CONF/${nombreDominio}.conf

    # Configuramos el ServerName del dominio de Apache en la plantilla
    sed -i "s/ServerName.*/ServerName ${nombreDominio}/g" $MIBASEDIR/CONF/${nombreDominio}.conf

    # Configuramos el mail del Administrador del dominio de Apache
    sed -i "s/ServerAdmin.*/ServerAdmin ${adminEmail}/g" $MIBASEDIR/CONF/${nombreDominio}.conf

    # Configuramos el directorio de logs de apache (acceso y errores)
    sed -i "s=ErrorLog.*=ErrorLog /var/log/apache2/${nombreDominio}/error.log=g" $MIBASEDIR/CONF/${nombreDominio}.conf
    sed -i "s=CustomLog.*=CustomLog /var/log/apache2/${nombreDominio}/access.log combined=g" $MIBASEDIR/CONF/${nombreDominio}.conf

    # Configuramos el directorio raiz (DocumentRoot) en la plantilla.
    sed -i "s=DocumentRoot.*=DocumentRoot /var/www/${nombreDominio}=g" $MIBASEDIR/CONF/${nombreDominio}.conf

    registro "ApacheVirtualHost" "Fichero de configuración para el dominio ${nombreDominio} generada correctamente."
}

function prepararEntorno(){
    ##########################################################################################
    # Esta funcion realiza los cambios necesarios a nivel sistema operativo.
    ##########################################################################################

    # Generamos la contraseña para el usuario con 8 caracteres de longitud:
    contrasenya=`openssl rand -base64 6`

   # Creamos el usuario en el sistema
    sudo useradd -m -c "Usuario SFTP del dominio "${nombreDominio}  ${usuario}

    # cambiamos la contraseña del usuario segun la que ha sido generada anteriormente
    echo ${usuario}:${contrasenya} | sudo chpasswd 

    registro "ApacheVirtualHost" "El usuario ${usuario} con password ${contrasenya} para el dominio ${nombreDominio} ha sido creado correctamente"

    # creamos el directorio raiz del dominio
    sudo mkdir -p /var/www/${nombreDominio}
    sudo mkdir -p /var/log/apache2/${nombreDominio}
    
    # Modificamos los permisos del directorio root del dominio.
    sudo chown -R ${usuario}:${usuario} /var/www/${nombreDominio}

    # Creamos un fichero index.html como pagina de inicio para el dominio configurado
    echo "<html><head></head><body><h1> `i18n_muestra welcome` ${nombreDominio}</h1></body></html>" > $MIBASEDIR/CONF/index.html


    # creamos un enlace simbólico en el home del usuario que apunte al DocumentRoot de su dominio
    sudo ln -s /var/www/${nombreDominio} /home/${usuario}/${nombreDominio}
    sudo chown -R ${usuario}:${usuario} /home/${usuario}/${nombreDominio}

    # Copiamos el indice de muestra en el enlace del document root del dominio.
    sudo cp $MIBASEDIR/CONF/index.html /home/${usuario}/${nombreDominio}/index.html

    registro "ApacheVirtualHost" "Se ha configurado correctamente el dominio ${nombreDominio}"


}
function  activaDominio(){
    # Copiamos el fichero de configuracion generado al directorio de sitios disponibles de apache (sites available)
    sudo cp $MIBASEDIR/CONF/${nombreDominio}.conf /etc/apache2/sites-available

    # A continuacion activamos el sitio en apache
    sudo a2ensite ${nombreDominio} > /dev/null 2> /dev/null

    # Reiniciamos Apache
    sudo systemctl restart apache2

    # Añadimos el dominio a la ip localhost (127.0.0.1) para acceder por nombre 
    sudo sed -i "2i127.0.0.1  ${nombreDominio}" /etc/hosts

    # Informamos al usuario del resultado del proceso.
    printf "\n\n"
    printf "`i18n_muestra dominioconfigurado`: ${VERDE}${nombreDominio}${NC}\n"
    printf "`i18n_muestra usuarioacceso` ${VERDE}${usuario}${NC}\n"
    printf "`i18n_muestra passacceso` ${VERDE}${contrasenya}${NC}\n"
    printf "`i18n_muestra validadominio`${VERDE} http://${nombreDominio}${NC}\n"
    registro "ApacheVirtualHost" "Configuración de apache completa para el dominio ${nombreDominio} (http://${nombreDominio})"
}
obtenerDatosDominio
preparaPlantilla
prepararEntorno
activaDominio
export TEXTDOMAIN=principal
echo
echo `i18n_muestra presionartecla`
read -n1 -s