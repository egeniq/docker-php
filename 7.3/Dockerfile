FROM php:7.3-apache

MAINTAINER Richard Tuin <richard@egeniq.com>

RUN usermod -a -G root www-data

RUN apt-get update && apt-get install -y curl wget git zlib1g-dev libzip-dev locales unzip && rm -rf /var/lib/apt/lists/*

# Locales
COPY assets/locale.gen /etc/locale.gen
RUN locale-gen

# PHP
RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-install mysqli && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install opcache && \
    docker-php-ext-install zip

COPY ./assets/php-custom.ini /usr/local/etc/php/conf.d/zzz-custom.ini

# Apache
RUN a2enmod rewrite
COPY ./assets/vhost.conf /etc/apache2/sites-available/000-default.conf

# Scripts
COPY ./assets/entrypoint.sh /entrypoint.sh
COPY ./assets/install_composer.sh /install_composer.sh

RUN /install_composer.sh && \
    mv composer.phar /usr/local/bin/composer && \
    rm /install_composer.sh

RUN composer global require hirak/prestissimo

ONBUILD COPY src /src

# Preferably run composer install during build-time
ONBUILD RUN if [ -f "composer.json" ] && [ ! -d "vendor/composer" ]; then composer install --prefer-dist --no-progress --no-ansi -a -n; fi

WORKDIR /src

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
