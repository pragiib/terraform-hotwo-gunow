#!/bin/bash
sudo apt update
sudo apt install nginx -y
echo "<h2>Hello</h2>" > /usr/share/nginx/html/index.html
