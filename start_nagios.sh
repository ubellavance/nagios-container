docker run -itd \
--hostname=nagios.localhost.com \
--restart=always \
--add-host=nagios.localhost.com:xxx.xxx.xxx.xxx \
-v /usr/share/zoneinfo/America/Denver:/etc/localtime \
-p xxx.xxx.xxx.xxx:80:80 \
-p xxx.xxx.xxx.xxx:443:443 \
bosman/nagios:latest
