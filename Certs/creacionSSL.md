# Script de creación de un certificado de CA (Entidad de Certificación.)

## Autor : Miguel Ángel de Dios

Este script genera la clave privada (private key), y los certificados de CA el cual se utiliza para la posterior generación del certificado seguro. Utilizando esta CA, podemos a partir de un CSR, generar los certificados que posteriormente serán instalados en apache para identificar el sitio web.

Comandos utilizados:

* echo
* cp
* read
* sed
