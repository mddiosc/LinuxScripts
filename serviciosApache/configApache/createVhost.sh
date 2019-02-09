export DIRBASE=$PWD
echo $DIRBASE
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
#           fqdn: Nombre completo del dominio para el que se generará el certifiado
#           email: Correo electrónico de contacto del responsable del dominio.
#
##########################################################################################

function obtenerDatosDominio() {
    ##########################################################################################
    # Esta funcion obtiene los datos del certificado a emitir
    ##########################################################################################
    # Establecer el pais por defecto en ES (España), y solicita los datos necesarios 
    # para el certificado.
    #
    clear
    echo "Por favor introduzca los datos que se solicitan a continuación"
    echo "Serán utilizados para generar el nuevo dominio en apache"
    echo 
    echo 
    read -p "Nombre de Dominio: "  nombreDominio
    read -p "Email del administrador: " adminEmail
    read -p "Usuario SFTP: " usuario
}

function preparaPlantilla(){
    # Copiamos la plantilla base que sera editada e instalada en apache.
    cat PLT/000-default.conf | grep -v "#" > $DIRBASE/CONF/${nombreDominio}.conf

    # Configuramos el ServerName del dominio de Apache en la plantilla
    sed -i "s/ServerName.*/ServerName ${nombreDominio}/g" $DIRBASE/CONF/${nombreDominio}.conf

    # Configuramos el mail del Administrador del dominio de Apache
    sed -i "s/ServerAdmin.*/ServerAdmin ${adminEmail}/g" $DIRBASE/CONF/${nombreDominio}.conf

    # Configuramos el directorio de logs de apache (acceso y errores)
    sed -i "s=ErrorLog.*=ErrorLog /var/log/apache2/${nombreDominio}/error.log=g" $DIRBASE/CONF/${nombreDominio}.conf
    sed -i "s=CustomLog.*=CustomLog /var/log/apache2/${nombreDominio}/access.log combined=g" $DIRBASE/CONF/${nombreDominio}.conf

    # Configuramos el directorio raiz (DocumentRoot) en la plantilla.
    sed -i "s=DocumentRoot.*=DocumentRoot /var/www/${nombreDominio}=g" $DIRBASE/CONF/${nombreDominio}.conf
}

function prepararEntorno(){
    # Configuramos y creamos el directorio raiz del dominio de Apache
    # y ponemos un fichero indice de prueba. Dado que el directorio pertenece al usuario estamos obligados
    # a hacer un doble sudo para poder crearlo.

   
    # Creamos el usuario en el sistema, y le asignamos como home el Document Root.
    # Generamos la contraseña para el usuario con 8 caracteres de longitud:
    contrasenya=`openssl rand -base64 6`

    # añadimos al usuario al sistema
    sudo useradd -m -c "Usuario SFTP del dominio"${nombreDominio}  ${usuario}

    # cambiamos la contraseña del usuario segun la que ha sido generada anteriormente
    echo ${usuario}:${contrasenya} | sudo chpasswd 

    # creamos el directorio raiz del dominio
    sudo mkdir -p /var/www/${nombreDominio}
    sudo mkdir -p /var/log/apache2/${nombreDominio}
    
    # Modificamos los permisos del directorio root del dominio.
    sudo chown -R ${usuario}:${usuario} /var/www/${nombreDominio}

    # Inyectamos un fichero index.html como landing page
    echo "<html><head></head><body><h1> Bienvenido al dominio ${nombreDominio}</h1></body></html>" > $DIRBASE/CONF/index.html


    # creamos un enlace simbólico en el home del usuario que apunte al DocumentRoot de su dominio
    sudo ln -s /var/www/${nombreDominio} /home/${usuario}/${nombreDominio}
    sudo chown -R ${usuario}:${usuario} /home/${usuario}/${nombreDominio}
    sudo cp $DIRBASE/CONF/index.html /home/${usuario}/${nombreDominio}/index.html

}
function  activaDominio(){
    sudo cp $DIRBASE/CONF/${nombreDominio}.conf /etc/apache2/sites-enabled
    sudo systemctl restart apache2
    sudo sed -i "2i127.0.0.1  ${nombreDominio}" /etc/hosts
    echo "El usuario de acceso es "${usuario}
    echo "Su contraseña es "${contrasenya}
    echo "Puede validar su dominio conectandose a http://"${nombreDominio}
}
obtenerDatosDominio
preparaPlantilla
prepararEntorno
activaDominio
