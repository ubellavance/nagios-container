#!/bin/sh
# Lets checkconfig these to always startup
<<<<<<< HEAD
RUN for startup in nrpe crond httpd nagios;do /sbin/chkconfig $startup on;done

# Configure services to star
RUN for service in nrpe crond httpd nagios;do /sbin/service $service start;done
=======
for startup in nrpe crond httpd nagios sendmail; do /sbin/chkconfig $startup on; done

# Configure services to star
for service in nrpe crond httpd nagios sendmail; do /sbin/service $service start; done
>>>>>>> 1c651cb8442c63621cc69669f8df58f8552e4309
