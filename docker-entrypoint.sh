#!/bin/sh


# setup site_config.json
dockerize -template /tmp/config/site_config.json.tmpl:/home/$FRAPPE_USER/frappe-bench/sites/common_site_config.json \
          true





/bin/bash
