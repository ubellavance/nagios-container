#!/bin/bash
docker run -itd \
--name nagios \
--restart=always \
-p 80:80 \
-p 443:443 \
-p 123:123 \
bosman/nagios:latest
