# Lets checkconfig these to always startup
RUN for startup in nrpe crond httpd nagios sendmail;do /sbin/chkconfig $startup on;done

# Configure services to star
RUN for service in nrpe crond httpd nagios sendmail;do /sbin/service $service start;done
