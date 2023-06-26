FROM prestashop/prestashop:1.6-7.2-apache

WORKDIR "/var/www/html/"

RUN usermod -aG root www-data
RUN chown -R www-data ./ && chgrp -R root ./