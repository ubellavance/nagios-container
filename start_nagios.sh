#!/bin/bash
docker run -itd \
--entrypoint /bin/bash \
--name nagios \
--hostname nagios.example.com \
--restart=always \
-p 80:80 \
-p 443:443 \
bosman/nagios:latest
