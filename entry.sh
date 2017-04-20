#!/bin/bash
/etc/init.d/httpd start
/etc/init.d/postfix start
/etc/init.d/crond start
/etc/init.d/nrpe start
/etc/init.d/nagios start

/bin/bash
