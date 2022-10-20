#!/bin/bash
sudo apt update
sudo apt install nginx -y
echo "<h3>Hello</h3>" > /usr/share/nginx/html/index.html
