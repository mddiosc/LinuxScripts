# Script de configuación de un sitio SSL en apache

## Autor : Miguel Ángel de Dios

Este script configura un sitio SSL en apache. Para su correcto funcionamiento es necesario haber creado previamente:

* Sitio HTTP (script creacionVhost.sh)
* Certificado y Clave Privada para el dominio (scripts Certs/creacionCSR.sh y Certs/creacionSSL.sh)

Durante la ejecución se verifica si los modulos de soporte para ssl estan habilitados y si no lo están se habilitan.
Para verificar si el módulo apache esta habilitado, utilizamos el comando a2query -m *modulo*

* a2query -m ssl


Para habilitar el modulo de SSL utilizando a2enmod (Apache2 Enable Module)

* a2enmod ssl

Lo cual activa todos los módulos necesarios para servir contenido via SSL (HTTPS)

Una vez habilitado el ssl y creado el Virtual Host, se puede validar que ha sido habilitado correctamente utilizando el comando apachectl -S, el cual nos informa de los sitios, ip y puertos habilitados por apache.

``` bash
sudo apachectl -S
```




Comandos utilizados:

* echo
* cp
* read
* sed
