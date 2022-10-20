#!/bin/bash
sudo apt update
sudo apt install nginx -y
echo "<h1>Hello WORLD</h1>" > /usr/share/nginx/html/index.html
