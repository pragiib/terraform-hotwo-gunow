#!/bin/bash
sudo mkdir -p /etc/grid-router/quota/
sudo htpasswd -bc /etc/grid-router/users.htpasswd company company-pass
sudo touch /etc/grid-router/quota/test.xml
sudo chmod 775 /etc/grid-router/quota/test.xml
cat <<EOT >> /etc/grid-router/quota/test.xml
<qa:browsers xmlns:qa="urn:config.company.vdr">
<browser name="chrome" defaultVersion="88.0">
    <version number="101.0">
        <region name="eu-central-1">
            <host name="selenoid.example.com" port="4444" count="1"/>
        </region>
    </version>
</browser>
</qa:browsers>
EOT
sudo docker run -d --name \
ggr -v /etc/grid-router/:/etc/grid-router:ro \
    --net host aerokube/ggr:latest-release