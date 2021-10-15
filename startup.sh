#!/bin/bash
sudo service postgresql start

# sudo su postgres
# psql -d postgres -c "CREATE USER dcpms WITH PASSWORD 'dcpms';"
# psql -d postgres -c "ALTER ROLE dcpms superuser;"
# psql -v ON_ERROR_STOP=1 -d postgres -c "CREATE DATABASE dcpms OWNER 'dcpms';"
# exec "$@"
sudo su - dcpms
# source /home/dcpms/unifi_virtualenv2.7/bin/activate
# cd /usr/local/dev/ansible-playbook-boomi-identity/ && pip install -r requirements.txt

# deactivate
# source /home/dcpms/orchestrator_virtualenv/bin/activate
# cd /usr/local/dev/unifi-managed-service/dcp-managed-service-ui && pip install -r requirements.txt
sudo cp /usr/local/dev/unifi-managed-service/dcp-managed-service-ui/ext/nginx/dcp-managed-service-ui.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/dcp-managed-service-ui.conf /etc/nginx/sites-enabled/dcp-managed-service-ui.conf
sudo ln -s /usr/local/dev/dcp-managed-service-ui/lib/unifi/ /home/dcpms/orchestrator_virtualenv/lib/python3.8/site-packages/unifi
# echo '[sandboxs3access]
# role_arn=arn:aws:iam::429212808017:role/admin
# source_profile=boomi' >> ~/.aws/credentials
# aws s3 mb s3://rc-local-orchestrator-backup
# /usr/local/dev/dcp-managed-service-ui/www/manage.py migrate
# /usr/local/dev/dcp-managed-service-ui/www/manage.py createsuperuser
# redis-server &
# cd /usr/local/dev/dcp-managed-service-ui/www/ && python manage.py runserver 0.0.0.0:8001 --insecure &
# celery -A webui worker -l debug &
while true; do sleep 1000; done
