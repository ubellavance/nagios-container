# Lets checkconfig these to always startup
for startup in nrpe crond httpd nagios sendmail; do /sbin/chkconfig $startup on; done

# Configure services to star
for service in nrpe crond httpd nagios sendmail; do /sbin/service $service start; done
