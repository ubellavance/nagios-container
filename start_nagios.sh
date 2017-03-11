#!/bin/bash
docker run -itd \
--name nagios \
--hostname nagios.example.com \
-v /usr/share/zoneinfo/America/Denver:/etc/localtime \
--restart=always \
-p 80:80 \
-p 443:443 \
bosman/nagios:latest
