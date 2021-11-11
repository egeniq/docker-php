FROM php:7.4-fpm

MAINTAINER Richard Tuin <richard@egeniq.com>

RUN usermod -a -G root www-data

RUN apt-get update \
    && apt-get install -y curl wget git zlib1g-dev libzip-dev locales gnupg unzip \
    && rm -rf /var/lib/apt/lists/*

COPY ./assets/nginx_signing.key /root/nginx_signing.key
RUN apt-key add /root/nginx_signing.key

RUN echo "deb http://nginx.org/packages/mainline/debian/ bullseye nginx" > /etc/apt/sources.list.d/nginx60.list
RUN echo "deb-src http://nginx.org/packages/mainline/debian/ bullseye nginx" >> /etc/apt/sources.list.d/nginx60.list

RUN apt-get update \
    && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/*

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
COPY ./assets/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

# Nginx
RUN sed -i 's/user  nginx;/user  www-data;/' /etc/nginx/nginx.conf
COPY ./assets/site.conf /etc/nginx/conf.d/default.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Scripts
COPY ./assets/entrypoint.sh /entrypoint.sh
COPY ./assets/install_composer.sh /install_composer.sh

RUN /install_composer.sh && \
    mv composer.phar /usr/local/bin/composer && \
    rm /install_composer.sh

# RUN composer global require hirak/prestissimo

ONBUILD COPY src /src

# Preferably run composer install during build-time
ONBUILD RUN if [ -f "composer.json" ] && [ ! -d "vendor/composer" ]; then composer install --prefer-dist --no-progress --no-ansi -a -n; fi

WORKDIR /src

ENTRYPOINT ["/entrypoint.sh"]
