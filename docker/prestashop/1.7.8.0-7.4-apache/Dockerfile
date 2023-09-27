FROM prestashop/prestashop:1.7.8.0-7.4-apache

WORKDIR "/var/www/html/"
RUN apt-get update && \
    apt-get install -y zlib1g-dev libpng-dev libjpeg-dev

RUN docker-php-ext-install  bcmath json mbstring openssl xml zip imap curl 

RUN docker-php-ext-configure gd --with-jpeg && \
    docker-php-ext-install gd

    