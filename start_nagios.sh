#!/bin/bash
docker run -itd \
--name nagios \
--restart=always \
-p 80:80 \
-p 443:443 \
bosman/nagios:latest
