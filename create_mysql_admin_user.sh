#!/bin/bash

if [ -f /.mysql_admin_created ]; then
    echo "MySQL 'admin' user already created!"
    exit 0
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

PASS=admin
_word=$PASS
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

echo "=> Creating MySQL admin user with ${_word} password"
mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

mysqladmin -uroot shutdown

echo "=> Done!"
touch /.mysql_admin_created
