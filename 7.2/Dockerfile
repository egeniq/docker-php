FROM php:7.2-apache

MAINTAINER Richard Tuin <richard@egeniq.com>

RUN usermod -a -G root www-data

RUN apt-get update && apt-get install -y curl wget git zlib1g-dev

RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-install mysqli && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install opcache && \
    docker-php-ext-install zip

RUN a2enmod rewrite

COPY ./assets/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY ./assets/entrypoint.sh /entrypoint.sh
COPY ./assets/install_composer.sh /install_composer.sh
COPY ./assets/php-custom.ini /usr/local/etc/php/conf.d/zzz-custom.ini

RUN /install_composer.sh && \
    mv composer.phar /usr/local/bin/composer && \
    rm /install_composer.sh

ONBUILD COPY src /src

# Preferably run composer install during build-time
ONBUILD RUN if [ -f "composer.json" ] && [ ! -d "vendor/composer" ]; then composer install -a; fi

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
