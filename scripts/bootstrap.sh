#!/bin/bash

sudo apt update

sudo apt install -y nginx certbot python3-certbot-nginx

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

source ~/.bashrc

nvm install --lts

sudo systemctl enable nginx

sudo systemctl start nginx

sudo cat > /etc/nginx/conf.d/api.conf <<EOF
server {
    
     listen 80 default_server;
     server_name api.example.com;

     location / {
        proxy_pass http://127.0.0.1:5000/;
        proxy_redirect off;
        proxy_read_timeout 240s;
    }
}
EOF

sudo cat > /etc/nginx/conf.d/web.conf <<EOF
server {
     listen 80 default_server;
     server_name web.example.com;

     location / {
        proxy_pass http://127.0.0.1:3000/;
        proxy_redirect off;
        proxy_read_timeout 240s;
    }
}
EOF

certbot run -n --nginx --agree-tos -d web.example.com,api.example.com  -m  wlrfernando@outlook.com  --redirect

sudo systemctl reload nginx