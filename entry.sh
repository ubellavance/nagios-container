# Start supporting services
/etc/init.d/httpd start
/etc/init.d/postfix start
/etc/init.d/crond start
/etc/init.d/nrpe start

exec ${NAGIOS_BIN}/nagios ${NAGIOS_HOME}/nagios.cfg
