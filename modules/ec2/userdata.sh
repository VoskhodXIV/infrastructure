#!/bin/bash

cd /home/ubuntu/webapp || exit
mv .env .env.bak
touch .env
{
  echo "ENVIRONMENT=$ENVIRONMENT"
  echo "PORT=1337"
  echo "DATABASE=$DATABASE"
  echo "HOSTNAME=localhost"
  echo "DBUSER=$DBUSER"
  echo "DBPASSWORD=$DBPASSWORD"
} >>.env

sudo systemctl enable nodeserver.service
sudo systemctl start nodeserver.service
