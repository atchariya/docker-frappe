#!/bin/sh


# setup site_config.json
dockerize -template /tmp/config/site_config.json.tmpl:/home/$FRAPPE_USER/frappe-bench/sites/common_site_config.json \
          true
chmod 440 /home/$FRAPPE_USER/frappe-bench/sites/common_site_config.json 

sudo /usr/bin/supervisord

echo "wait ..."
sleep 10

cd /home/$FRAPPE_USER/frappe-bench
#bench new-site demo.megenius.cloud --mariadb-root-password=$DB_PASSWORD --admin-password=$ADMIN_PASSWORD
bench setup nginx
sudo service nginx restart


/bin/bash
