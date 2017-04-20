# nagios-container
=======
Dockerfile for Nagios container
This is a basic Dockerfile that will use CentOS6.7.  It installs all the necessary rpm's to run an out of the box nagos container.  Once the container is started nagios and related services should be up and running.  You will need to add your servers, and service checks to start monitoring your boxes.

A basic run script to start you container would be like this. Copy and past into you vim editor, chmod 755 the file and run it.  Nagios should be up and running:

#!/bin/bash
docker run -itd \
--name nagios \
--restart=always \
-p 80:80 \
-p 443:443 \
-p 123:123 \
bosman/nagios:latest

If you want to configure you nagios server with persistent storage so you can modify and change your configs for nagios without altering configs within the container (you will still need to restart nagios inside the container) add "-v /etc/nagios:/etc/nagios \" to your start script (assuming /etc/nagios is the volume you wanted to store your configs in on the host server).  This makes removing and upgrading your container much easier as your config files will always remain on the persistent volume on the host.
