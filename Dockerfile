FROM nforceroh/d_alpine-s6:v3.10

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
    && apk add php7 php7-common php7-fpm php7-sqlite3 php7-json php7-phar php7-openssl php7-iconv \
        php7-pdo php7-pdo_mysql php7-xml php7-mbstring \
        git mariadb-client nginx \
#    && apk add php5 php5-common php5-cli php5-fpm php5-opcache php5-dom php5-xml php5-xmlreader \
#        php5-ctype php5-ftp php5-gd php5-json php5-posix php5-curl php5-pdo php5-pdo_mysql \
#        php5-sockets php5-zlib php5-mcrypt php5-pcntl php5-mysql php5-mysqli php5-sqlite3 \ 
#        php5-bz2 php5-pear php5-exif php5-phar php5-openssl php5-zip php5-calendar php5-iconv \
#        php5-imap php5-soap php5-ldap php5-bcmath php-gettext \
#        git mariadb-client nginx \
#    && ln -s /usr/bin/php5 /usr/bin/php \
    && wget -qO- https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer -n create-project opensolutions/vimbadmin ${INSTALL_PATH} -s dev \
#    && chown -R www-data:www-data ${INSTALL_PATH}/var \
    && rm -rf /var/cache/apk/* /tmp/* 

COPY install/. /

WORKDIR ${INSTALL_PATH}

EXPOSE 80

CMD /bin/bash

