#!/bin/bash -eux

for ((i=0;i<10;i++))
do
    DB_CONNECTABLE=$(mysql -u ${VIMBADMIN_DB_USER} -p${VIMBADMIN_DB_PASSWORD} -h ${VIMBADMIN_DB_HOST} -P3306 -e 'status' >/dev/null 2>&1; echo "$?")
    if [[ DB_CONNECTABLE -eq 0 ]]; then
      if [ $(mysql -N -s -u ${VIMBADMIN_DB_USER} -p${VIMBADMIN_DB_PASSWORD} -h ${VIMBADMIN_DB_HOST} -e \
        "select count(*) from information_schema.tables where \
          table_schema='${VIMBADMIN_DB_NAME}' and table_name='domain';") -eq 1 ]; then
        exec "$@"
      else
        echo "Creating DB and Superuser"
        HASH_PASS=`php -r "echo password_hash('${ADMIN_PASSWORD}', PASSWORD_DEFAULT);"`
        ./bin/doctrine2-cli.php orm:schema-tool:create
        mysql -u ${VIMBADMIN_DB_USER} -p${VIMBADMIN_DB_PASSWORD} -h ${VIMBADMIN_DB_HOST} ${VIMBADMIN_DB_NAME} -e \
          "INSERT INTO admin (username, password, super, active, created, modified) VALUES ('${ADMIN_EMAIL}', '$HASH_PASS', 1, 1, NOW(), NOW())" && \
        echo "Vimbadmin setup completed successfully"
        exec "$@"
      fi
    fi
    sleep 5
done
exit 1
