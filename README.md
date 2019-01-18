# Egeniq's PHP + a webserver Docker image

These Docker images are based on the official PHP images, 
with several complementary packages and sensible default 
configuration options for production-grade deployments.

## Supported tags

* 5.6-onbuild (uses apache)
* 7.2-onbuild (uses apache)
* 7.3-onbuild (uses apache)
* 7.2-nginx-onbuild

## Installed packages and extensions
* Composer
* PHP Extensions
    * mysqli
    * pdo_mysql
    * opcache
    * zip

## Expected project structure

These images expect you to put your source code in the relative `./src` directory. 
During build, the contents of `./src` are copied to the container's `/src` directory.

The web server's document root is at `/src/public`.

## How to use this image

### Create a Dockerfile
To use these base images you need to create a Dockerfile for your own project, too.
This is necessary to have Docker copy your PHP source files to the Docker image.

The Dockerfile can be empty if you have nothing to customize, for example:

```
FROM egeniq/php:7.2-onbuild
```


### With docker-compose

Once you have a Dockerfile for your image, you can use `docker-compose` to start the container and host your code.
An example `docker-compose.yml` would look like this:

```
version: '3'

services:
  myphpservice:
    build:
      context: .
    ports:
      - "8000:80"
    volumes:
      - ./src:/src:cached
```

### Important default configurations

| Component | Key               | Value                                                   |
| ----------| ----------------- | ------------------------------------------------------- |
| PHP       | date.timezone     | Europe/Amsterdam                                        |
| OS        | Installed locales | nl_NL.UTF-8 UTF-8, en_GB.UTF-8 UTF-8, en_US.UTF-8 UTF-8 |
