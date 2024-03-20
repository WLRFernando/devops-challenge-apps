#!/bin/bash

app_name=$1

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

if [[ "$app_name" != "api" ]] && [[ "$app_name" != "web" ]]; then
    echo "Illegal parameters"
    exit 1
fi

npm i -g pm2

cd /var/www

git clone git@github.com:WLRFernando/devops-challenge-apps.git

cd devops-challenge-apps

if [[ "$app_name" == "api" ]]; then
    cd api
    ## add DB_USER DB_PASSWORD DB_DATABASE DB_HOST to environment
    npm i
    PORT=5000  pm2 start npm --name "api" -- start
fi

if [[ "$app_name" == "web" ]]; then
    cd web
    npm i
    PORT=3000 API_HOST="https://api.example.com"  pm2 start npm --name "web" -- start
fi

