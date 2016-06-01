# nagios-container
<<<<<<< HEAD
=======
Dockerfile for Nagios container
This is a basic Dockerfile that will use CentOS6.7.  It installs all the necessary rpm's to run an out of the box nagos container.  Once the container is started nagios and related services should be up and running.  You will need to add your servers, and service checks to start monitoring your boxes.

A basic run script to start you container would be like this. Copy and past into you vim editor, chmod 755 the file and start it.  Nagios should be up and running:

#!/bin/bash
docker run -itd \
--name nagios \
--restart=always \
-p 80:80 \
-p 443:443 \
-p 123:123 \
bosman/nagios:latest


>>>>>>> 1fa3351d2365224fdc7e1e1058778fc0c1c66f8f
