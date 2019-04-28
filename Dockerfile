FROM nforceroh/alpine-s6:3.8

LABEL maintainer Sylvain Martin sylvain@nforcer.com

ENV LANG=en_US.utf8 \
    MEMCACHED_MEMORY=128 \
    MEMCACHED_MAX_CONNECTIONS=1024 \
    MEMCACHED_MAX_ITEM_SIZE=4M \
    OPCACHE_MEM_SIZE=128 \
    INSTALL_PATH=/srv/vimbadmin \
    VIMBADMIN_DB_NAME=vimbadmin \
    VIMBADMIN_DB_USER=vimbadmin2 \
    VIMBADMIN_DB_PASSWORD=vimbadmin2 \
    VIMBADMIN_DB_HOST=db \
    ADMIN_EMAIL=postmaster@example.com \
    ADMIN_PASSWORD=CHANGEME \
    SMTP_HOST=mail

RUN echo "Updating image and installing base packages" \
    && apk update && apk upgrade \
    && apk add php5 php5-common php5-cli php5-fpm php5-opcache php5-dom php5-xml php5-xmlreader \
        php5-ctype php5-ftp php5-gd php5-json php5-posix php5-curl php5-pdo php5-pdo_mysql \
        php5-sockets php5-zlib php5-mcrypt php5-pcntl php5-mysql php5-mysqli php5-sqlite3 \ 
        php5-bz2 php5-pear php5-exif php5-phar php5-openssl php5-zip php5-calendar php5-iconv \
        php5-imap php5-soap php5-ldap php5-bcmath php-gettext \
        git mariadb-client nginx \
    && ln -s /usr/bin/php5 /usr/bin/php \
    && wget -qO- https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer create-project opensolutions/vimbadmin ${INSTALL_PATH} -s dev \
    && rm -rf /var/cache/apk/* /tmp/* 

COPY install/. /

WORKDIR /var/www/vimbadmin

EXPOSE 80

CMD /bin/bash

