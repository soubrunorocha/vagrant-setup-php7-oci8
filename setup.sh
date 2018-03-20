#!/bin/bash

echo "---- Iniciando instalacao do ambiente de Desenvolvimento PHP [EspecializaTI] ---"

echo "--- Atualizando lista de pacotes ---"
sudo apt-get update

echo "--- Definindo Senha padrao para o MySQL e suas ferramentas ---"

DEFAULTPASS="vagrant"
sudo debconf-set-selections <<EOF
mysql-server	mysql-server/root_password password $DEFAULTPASS
mysql-server	mysql-server/root_password_again password $DEFAULTPASS
dbconfig-common	dbconfig-common/mysql/app-pass password $DEFAULTPASS
dbconfig-common	dbconfig-common/mysql/admin-pass password $DEFAULTPASS
dbconfig-common	dbconfig-common/password-confirm password $DEFAULTPASS
dbconfig-common	dbconfig-common/app-password-confirm password $DEFAULTPASS
phpmyadmin		phpmyadmin/reconfigure-webserver multiselect apache2
phpmyadmin		phpmyadmin/dbconfig-install boolean true
phpmyadmin      phpmyadmin/app-password-confirm password $DEFAULTPASS 
phpmyadmin      phpmyadmin/mysql/admin-pass     password $DEFAULTPASS
phpmyadmin      phpmyadmin/password-confirm     password $DEFAULTPASS
phpmyadmin      phpmyadmin/setup-password       password $DEFAULTPASS
phpmyadmin      phpmyadmin/mysql/app-pass       password $DEFAULTPASS
EOF

echo "--- Instalando pacotes basicos ---"
sudo apt-get install software-properties-common vim curl python-software-properties git-core --assume-yes --force-yes

echo "--- Adicionando repositorio do pacote PHP ---"
sudo add-apt-repository ppa:ondrej/php

echo "--- Atualizando lista de pacotes ---"
sudo apt-get update

echo "--- Instalando MySQL, Phpmyadmin e alguns outros modulos ---"
sudo apt-get install mysql-server-5.5 mysql-client phpmyadmin --assume-yes --force-yes

echo "--- Instalando PHP, Apache e alguns modulos ---"
sudo apt-get install php7.1 php7.1-common --assume-yes --force-yes
sudo apt-get install php7.1-cli libapache2-mod-php7.1 php7.1-mysql php7.1-curl php-memcached php7.1-dev php7.1-mcrypt php7.1-sqlite3 php7.1-mbstring zip unzip --assume-yes --force-yes

echo "--- Habilitando o PHP 7.1 ---"
sudo a2dismod php5
sudo a2enmod php7.1

echo "--- Habilitando mod-rewrite do Apache ---"
sudo a2enmod rewrite

echo "--- Reiniciando Apache ---"
sudo service apache2 restart

echo "--- Baixando e Instalando Composer ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "--- Instalando Banco NoSQL -> Redis <- ---" 
sudo apt-get install redis-server --assume-yes
sudo apt-get install php7.1-redis --assume-yes

# Instale apartir daqui o que você desejar 

 # ORACLE
echo "################################# Install ORACLE Lib"
sudo dpkg -i /vagrant/oracle-instantclient12.2-basic_12.2.0.1.0-2_amd64.deb
sudo dpkg -i /vagrant/oracle-instantclient12.2-devel_12.2.0.1.0-2_amd64.deb
sudo tar -zxvf /vagrant/oci8-2.1.4.tgz
cd oci8-2.1.4/
sudo phpize
sudo ./configure --with-oci8=shared,instantclient,/usr/lib/oracle/12.2/client64/lib/
sudo make
sudo make install
sudo echo "extension=oci8.so" > /etc/php/7.1/mods-available/oci8.ini
sudo ln -s /etc/php/7.1/mods-available/oci8.ini /etc/php/7.1/cli/conf.d/99-oci8.ini
sudo ln -s /etc/php/7.1/mods-available/oci8.ini /etc/php/7.1/apache2/conf.d/99-oci8.ini



# SQL SERVER
echo "################################# Install SQL SERVER Lib"
sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/mssql-ubuntu-xenial-release/ xenial main" > /etc/apt/sources.list.d/mssqlpreview.list'
sudo apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893
sudo apt update
sudo ACCEPT_EULA=Y apt install -y msodbcsql unixodbc-dev-utf16  
sudo apt -y install unixodbc unixodbc-dev 
sudo pecl install sqlsrv
sudo pecl install pdo_sqlsrv
# add in php.ini
sudo echo 'extension=sqlsrv.so' >> /etc/php/7.1/cli/php.ini
sudo echo 'extension=pdo_sqlsrv.so' >> /etc/php/7.1/cli/php.ini
sudo echo 'extension=sqlsrv.so' >> /etc/php/7.1/apache2/php.ini
sudo echo 'extension=pdo_sqlsrv.so' >> /etc/php/7.1/apache2/php.ini

echo "[OK] --- Ambiente de desenvolvimento concluido ---"
