
export MIBASEDIR=$BASEDIR/Certs
# Establecemos el dominio correspondiente al fichero de idiomas para la seccion de certificados
export TEXTDOMAIN=certificados
clear
printf "${VERDE}***************************************************************************************${NC}\n"
printf "${VERDE} `i18n_muestra tituloCert`${NC}\n"
printf "${VERDE}***************************************************************************************${NC}\n\n"
# Cargamos las funciones de gestion de certificados
source $MIBASEDIR/creacionCertFunc.sh

# Ejecutamos una a una en orden las funciones relativas a la gestion de certificados.

# Solicitud de datos del certificado
echo `i18n_muestra introduceDatos`
echo
obtenerdatos
registro "Certificados" "Se han introducido los datos para el generar el certificado para el dominio ${fqdn}"
# Preparamos el CSR
preparaCSRConf
registro "Certificados" "se ha generado el CSR para el dominio ${fqdn} en la carpeta ${MIBASEDIR}/CSR"
# Generamos la clave privada (private key)
generaKey_CSR
registro "Certificados" "se ha generado el clave privada para el dominio ${fqdn} en la carpeta ${MIBASEDIR}/KEY"
# Generamos el certificado a partir del CSR y la KEY
generarCertificado
registro "Certificados" "se ha generado el certificado para el dominio ${fqdn} en la carpeta ${MIBASEDIR}/CERT"
# Restablecemos el dominio correspondiente al fichero de idiomas principal
export TEXTDOMAIN=principal

# Solicitamos al usuario presionar cualquier tecla para continuar. Para ello utilizamos read -n1 -s
# -n1 : lee un solo caracter
# -s : no muestra en pantalla el caracter introducido (silent)

echo `i18n_muestra presionartecla`
read -n1 -s

