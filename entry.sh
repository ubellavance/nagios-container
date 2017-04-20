# Start supporting services
/etc/init.d/httpd start
/etc/init.d/postfix start
/etc/init.d/crond start
/etc/init.d/nrpe start

exec ${NAGIOS_BIN}/usr/sbin/nagios ${NAGIOS_HOME}/nagios.cfg
