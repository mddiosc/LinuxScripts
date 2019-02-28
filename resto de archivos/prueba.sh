#!/bin/bash

source LAMP/function.sh

if [ -n "${1}" ]; then
    # Cambiar root password
    NEW_MYSQL_PASSWORD="${1}"
else
    echo "Uso:"
    echo "  Setup mysql root password: ${0} 'your_new_root_password'"
    exit 1
fi

SECURE_MYSQL=$(expect -c "

    set timeout 3
    spawn mysql_secure_installation
    expect \"New password:\"
    send \'$NEW_MYSQL_PASSWORD\r\'
    expect \"Re-enter new password:\"
    send \'$NEW_MYSQL_PASSWORD\r\'
    expect \"Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) :\"
    send \"y\r\"
    expect \"Remove anonymous users? (Press y|Y for Yes, any other key for No) :\"
    send \"y\r\"
    expect \"Disallow root login remotely? (Press y|Y for Yes, any other key for No) :\"
    send \"y\r\"
    expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) :\"
    send \"y\r\"
    expect \"Reload privilege tables now? (Press y|Y for Yes, any other key for No) :\"
    send \"y\r\"
    expect eof
    ")

      echo "$SECURE_MYSQL"