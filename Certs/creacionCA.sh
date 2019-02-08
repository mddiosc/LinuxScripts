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
#           nombreca: Nombre completo del dominio para el que se generará el certifiado
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
    read -p "Nombre CA: " nombreca
    read -p "Direccion email: " email
}
function preparaCAConf(){
    # Copiamos el fichero de configuracion para su preparación usando en nombre de la CA introducido
    cp $DIRBASE/PLT/CA.cnf $DIRBASE/CNF/${nombreca}.ca.cnf

    # Creamos el fichero de base de datos de CA
    touch $DIRBASE/CA/${nombreca}.db.txt

    # Creamos el fichero que gestiona los numeros de serie y lo inicializamos en 1000
    echo 1000 > $DIRBASE/CA/${nombreca}.serial

    # Sustituimos el nombre del directorio base DIRBASE de la plantilla copiada, para establecer 
    #la ubicacion de los ficheros
    sed -i "s/DIRBASE/${DIRBASE}/g" $DIRBASE/CNF/${nombreca}.ca.cnf

    # Sustituimos el nombre del fichero de la base de datos  de la plantilla (DATABASE), 
    # por el del fichero de texto creado
    sed -i "s/DATABASE/${nombreca}.db.txt/g" $DIRBASE/CNF/${nombreca}.ca.cnf 

     # Sustituimos el nombre del fichero de gestion de numeros de serie  de la plantilla (SERIAL), 
     # por el del fichero de texto creado
    sed -i "s/DATABASE/${nombreca}.serial/g" $DIRBASE/CNF/${nombreca}.ca.cnf 

    # Sustituimos el valor PRIVATEKEY para indicar el nombre de la clave privada, 
    sed -i "s/PRIVATEKEY/${nombreca}.CA.key.pem/g" $DIRBASE/CNF/${nombreca}.ca.cnf 

    # Sustituimos el valor CERTIFICATE para indicar el nombre del certificado raiz generado.
    sed -i "s/PRIVATEKEY/${nombreca}.CA.crt/g" $DIRBASE/CNF/${nombreca}.ca.cnf



}

function generarCAKey(){
    ##########################################################################################
    # Fase 1 de la generacion de la CA. Generación de la clave privada (private key) de la CA
    ########################################################################################## 
    
    # Generamos una contraseña segura para la key y la almacenamos en un fichero,:
    openssl rand -base64 32 > $DIRBASE/CA/${nombreca}pass.txt
    chmod 0700 $DIRBASE/CA/${nombreca}pass.txt

    #Generacion de la clave privada, encriptada mediante aea256 para securizarla al maximo con el mejor rendimiento
    openssl genrsa -aes256 -passout file:$DIRBASE/CA/${nombreca}pass.txt -out $DIRBASE/CA/${nombreca}_CA.key.pem
}
obtenerdatos
preparaCAConf
generarCAKey