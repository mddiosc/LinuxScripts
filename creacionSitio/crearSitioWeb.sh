export DIRBASE=$PWD
echo "Validando Usuario"
sudo echo "Usuario Validado"
echo $DIRBASE

source ${DIRBASE}/configApache/creacionVhost.sh

obtenerDatosDominio
echo $nombreDominio