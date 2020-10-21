FROM nforceroh/d_alpine-s6:edge

LABEL maintainer Sylvain Martin sylvain@nforcer.com
ENV LANG=en_US.utf8 \
    INSTALL_PATH=/var/www/vimbadmin \
    VIMBADMIN_DB_NAME=vimbadmin \
    VIMBADMIN_DB_USER=vimbadmin2 \
    VIMBADMIN_DB_PASSWORD=vimbadmin2 \
    VIMBADMIN_DB_HOST=db \
    ADMIN_EMAIL=postmaster@example.com \
    ADMIN_PASSWORD=CHANGEME \
    SMTP_HOST=mail \
    OPCACHE_MEM_SIZE=64 \
    VIMBADMIN_VERSION=3.2.1

RUN echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && BUILD_DEPS="gnupg tar build-base autoconf automake libtool" \
 && apk upgrade --update \
 && apk add ca-certificates openssl \
      php7-fpm php7 php7-phar php7-cgi php7-mcrypt php7-json php7-memcached php7-pdo php7-pdo_mysql php7-gettext php7-opcache \
      php7-ctype php7-dom php7-gd php7-iconv php7-json php7-xml php7-mbstring php7-posix php7-zip php7-zlib php7-openssl php7-simplexml \
      php7-pear php7-dev php7-tokenizer \
      git subversion nginx \
      bzip2 \
      sudo \
      mysql-client \
      patch \
      curl \
      zip unzip \
      bash \
 && echo "date.timezone = 'UTC'" >> /etc/php7/php.ini \
 && echo "short_open_tag = 0" >> /etc/php7/php.ini \
 && curl -sS https://getcomposer.org/installer | php7 -- --filename=composer --install-dir=/usr/local/bin \
 && mkdir -p $INSTALL_PATH \
 && git clone https://github.com/opensolutions/vimbadmin.git ${INSTALL_PATH} \
 && cd ${INSTALL_PATH} \
 && git checkout ${VIMBADMIN_VERSION} \
 && sed -i -e 's#"doctrine/orm": "2.4.*"#"doctrine/orm": "2.6.*"#' composer.json \
 && composer config -g secure-http false \
 && composer install \
 && rm -rf ${INSTALL_PATH}/.git /var/cache/apk/* /tmp/*

COPY ./install /

WORKDIR /var/www/vimbadmin
VOLUME /var/www/vimbadmin

EXPOSE 80 9000

ENTRYPOINT [ "/init" ]
#CMD  php-fpm7 -F