#!/usr/bin/env bash

echo "set ROOT_PASSWORD to ***"
sed -i "s/{{ROOT_PASSWORD}}/${ROOT_PASSWORD}/" sites/common_site_config.json

echo "set ADMIN_PASSWORD to ***"
sed -i "s/{{ADMIN_PASSWORD}}/${ADMIN_PASSWORD}/" sites/common_site_config.json

echo "set DB_HOST to ${DB_HOST}"
sed -i "s/{{DB_HOST}}/${DB_HOST}/" sites/common_site_config.json

echo "set DB_NAME to ${DB_NAME}"
sed -i "s/{{DB_NAME}}/${DB_NAME}/" sites/site1.local/site_config.json

echo "set DB_PASSWORD to ***"
sed -i "s/{{DB_PASSWORD}}/${DB_PASSWORD}/" sites/site1.local/site_config.json

echo "set ENCRYPTION_KEY to ***"
sed -i "s/{{ENCRYPTION_KEY}}/${ENCRYPTION_KEY}/" sites/site1.local/site_config.json

DEVELOPER_MODE=${DEVELOPER_MODE:-"0"}
echo "set DEVELOPER_MODE to ${DEVELOPER_MODE}"
sed -i "s/{{DEVELOPER_MODE}}/${DEVELOPER_MODE}/" sites/site1.local/site_config.json

WORKER=${WORKER:-"4"}
echo "set Worker to ${WORKER}"
sed -i "s/{{WORKER}}/${WORKER}/" /etc/supervisor/conf.d/supervisord.conf

echo "set bench values"
bench set-mariadb-host "${DB_HOST}"
bench set-admin-password "${ADMIN_PASSWORD}"
