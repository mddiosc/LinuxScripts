#########################################################################################
#
# Script de preparación del entorno de la apllicacion de gestion de herramientas web
# Script: preparaentorno.sh
#
# Autor: Miguel Ángel de Dios 
#
# Variables:
#           BASEDIR : Directorio raiz de la aplicacion. Se utiliza para controlar la posicion de cada módulo y sus componentes
#           ROJO, VERDE NC : Variables de cadena de escape para colorizar la impresión durante la generación del script
#                           NC : Sin color
#           opcion: Variable que controla la opción que ha seleccionado el usuario
#           TEXTDOMAINDIR: Variable de sistema utilizada para determinar la ubicación de los ficheros de catalogo de mensajes
#                           que son utilizados como bases de datos para la internacionalizacion de la aplicacion
#                           (soporte a varios lenguajes). El directorio de internacionalizacion es $BASEDIR/idiomas
#                           en el cual existe una carpeta con los ficheros de catalogo para cada uno de los idiomas
#                           soportados (actualmente es, y en)
#           TEXTDOMAIN: Esta variable de sistema permite especificar el dominio del catalogo de mensajes que sera utilizado en el script
#                       El nombre de dicho dominio debe coincidir con el nombre de fichero dentro de la carpeta de localización
#                       Así pues, para el caso de este script el dominio es "principal", el cual tiene un fichero equivalente en
#                       las carpetas de localizacion, con extensión .mo:
#                       Para inglés: $TEXTDOMAINDIR/en/LC_MESSAGES/principal.mo
#                       Para Español: $TEXTDOMAINDIR/es/LC_MESSAGES/principal.mo
#           idioma: Variable de control para el menu desplegado por select
#           REPLY : Variable de sistema, que recoge la respuesta del usuario ante las opciones mostradas por el select.
#           LANGUAGE: Variable de sistema, que permite establecer el idioma que debe utilizarse para desplegar los mensajes en la 
#                   ejecución del shell. En el script lo utilizamos para que el script i18n.sh devuelva las cadenas de texto en el 
#                   idioma correcto una vez seleccionado por el usuario.
#                   Para utilizar el catalogo de mensajes en español : LANGUAGE="es_ES"
#                   Para utilizar el catálogo de mensajes en ingles:  LANGUAGE="en_US"
#
##########################################################################################

clear
# Definimos el directorio base donde esta instalada la aplicacion
export BASEDIR=$PWD

function registro(){
    if [ $# -eq 2 ]
    then
        modulo=$1
        mensaje=$2
    elif [ $# -eq 1 ]
    then
        modulo="NoDefinido"
        mensaje=$1
    else 
        modulo="NoDefinido"
        mensaje="Error no especificado"
    fi
  
    fechaFichero=`date +%Y-%m-%d`
    timestamp=`date +"%Y-%m-%d %H:%M:%S"`
    echo "${timestamp} - [${modulo}] - ${mensaje}" >> ${BASEDIR}/logs/registro-${fechaFichero}.log
}

# Preparamos definicion de colores, para colorizar mensajes utilizando printf
export ROJO='\033[0;31m' # Color Rojo, fondo negro
export VERDE='\033[0;32m' # Color Verde, fondo negro
export NC='\033[0m' #Sin Color

# llamamos a la libreria de funciones que se utilizara para la localización.
source $BASEDIR/idiomas/i18n.sh

# Preguntamos al usuario el idioma en el cual desea que se ejecute
# la herramienta.
# Especificamos el directorio de localizacion (TEXTDOMAINDIR) Y Definimos el TEXTDOMAIN para este script,
# 
export TEXTDOMAINDIR=$BASEDIR/idiomas
export TEXTDOMAIN=principal

# preguntamos al usuario que idioma quiere utilizar para la aplicación.

# Mostramos la pregunta de seleccion de idioma en el idioma por defecto del sistema:
# funcion en el script (i18n.sh)
i18n_muestra idioma

# Mostramos las opciones de la pregunta de seleccion de idioma en el idioma por defecto del sistema:
# para ello utilizamos la funcion i18n_muestra del script i18n.sh
select idioma in `i18n_muestra es; i18n_muestra en`
    do 
        case $REPLY in
            1)
            # Si se selecciona español como idioma, se define la variable LANGUAGE a es_ES para que sea
            # utilizada por el gettext dentro de las funciones del script i18n.sh como idioma para enseñar los textos en castellano
            export LANGUAGE="es_ES"
            # desplegamos el mensaje de idioma seleccionado en castellano (es)
            echo `i18n_muestra seleccion` `i18n_muestra es`
            break
            ;;
            2)
            # Si se selecciona español como idioma, se define la variable LANGUAGE a en_US para que sea
            # utilizada por el gettext dentro de las funciones del script i18n.sh como idioma para enseñar los textos en inglés
            export LANGUAGE="en_US"
            #desplegamos el mensaje de idioma seleccionado en ingles  (en). 
            echo `i18n_muestra seleccion` `i18n_muestra en`
            break
            ;;
        esac
    done
    echo `i18n_muestra validausuario`
    sudo echo `i18n_muestra usuariovalidado`
sleep 2



