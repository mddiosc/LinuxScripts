# #! /usr/bin/env bash
# https://www.linuxjournal.com/content/internationalizing-those-bash-scripts
# https://es.wikipedia.org/wiki/Internacionalizaci%C3%B3n_y_localizaci%C3%B3n
# Para la preparacion del entorno del lenguaje es necesario crear los ficheros po, y mo
# para lo cual utilizamos la herramienta poedit.


function i18n_lee(){
        #Esta funcion despliega un prompt en el idioma definido por el valor de la variable LANGUAGE
        # y devuelve al valor leido para ser asignado a la variable.
        # $1 es la key correspondiente a la cadena a mostrar definida en el fichero .po
        read -p "$(gettext "$1"): " dato
        echo $dato
}

function i18n_muestra(){
    #Esta funcion despliega un texto en el idioma definido por el valor de la variable LANGUAGE
    # $1 es la key correspondiente a la cadena a mostrar, definida en el fichero .po
    echo "$(gettext -s "$1")"
}

function i18_log(){
    fichero = $1.log
    mensaje = $2
    echo $(gettext -s $mensaje) >> $BASEDIR/logs/$i 
}
function i18_error(){
    fichero = ${1}.err
    mensaje = $2
    echo  echo $(gettext -s $mensaje) >> $BASEDIR/logs/$i 
}