#!/bin/sh
DATABASE=${SERVICE_NAME}
mysql --host=${db_host}  -uroot -p${db_password} -e "CREATE DATABASE IF NOT EXISTS ${DATABASE} ;"
"${SERVICE_NAME}"/bin/"${SERVICE_NAME}" -Xms1024m -Xmx1800m