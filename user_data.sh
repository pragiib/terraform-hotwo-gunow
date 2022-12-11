#!/bin/bash
quota_dir=/etc/grid-router/quota

sudo mkdir -p $quota_dir
sudo htpasswd -bc /etc/grid-router/users.htpasswd company company-pass
sudo touch $quota_dir/test.xml
sudo chmod 775 $quota_dir/test.xml

cat <<EOT >> $quota_dir/test.xml
<qa:browsers xmlns:qa="urn:config.company.vdr">
<browser name="chrome" defaultVersion="101.0">
    <version number="101.0">
        <region name="eu-central-1">
            <host name="selenoid.example.com" port="4444" count="5"/>
        </region>
    </version>
</browser>
</qa:browsers>
EOT

sudo docker run -d --name ggr -v /etc/grid-router/:/etc/grid-router:ro \
    --net host aerokube/ggr:latest-release