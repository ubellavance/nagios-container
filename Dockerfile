# -----------------------------------------------------------------------------
# nagios-container
#
# Builds a basic docker image that can run nagios
#
# Authors: Bosman
# Updated: May 29th, 2016
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

# Base system is CentOS 6.7
FROM    centos:centos6
MAINTAINER "Bosman"
ENV container docker

# Environment paths
ENV PATH /sbin:/bin:/usr/sbin:/usr/bin

# Lets get the latest patches for CentOS
RUN yum clean all
RUN yum update -y

# Install Nagios prereq's and some common stuff (we will get the epel release for the nagios install).
RUN yum install -y httpd yum-utils php php-cli openssl mod_ssl perl epel-release sendmail crontabs bash-completion vim-common vim-enhanced mlocate wget unzip curl perl screen ntp man

# Add nagios and apache group and user info
RUN useradd nagios
RUN groupadd nagcmd
RUN usermod -a -G nagcmd nagios
RUN usermod -a -G nagcmd apache

# Get the nagios rpm's
RUN yum-config-manager --enable epel-testing
RUN yum clean all
RUN yum install -y nagios nrpe nagios-plugins-all pnp4nagios
RUN yum-config-manager --disable epel-testing

# Load in all of our config files.
ADD    ./configs/htpasswd.users /etc/nagios/passwd

# Fix for docker on Windows and OSX.  I have tested this container on Ubuntu, Centos, Windows 10, and OSX Yosemite.  This fixes oddball behavior in Windows and OSX.
RUN /bin/mkdir -p /var/run/nagios && /bin/chown nagios:apache /var/run/nagios && /bin/mkdir -p /var/log/nagios/rw && /bin/chown -R nagios:apache var/log/nagios/rw && /bin/chown -R nagios:apache /etc/nagios

# Start our services
RUN for service in nrpe nagios crond httpd sendmail;do service $service start;done

# Enable system services to start
RUN for enableme in nrpe nagios crond httpd sendmail;do /sbin/chkconfig $enableme on;done

# Disable Nagios Notifications (comment this out if you want notifications out of the box).
RUN perl -pi -e 's/^enable_notifications=1/enable_notifications=0/' /etc/nagios/nagios.cfg

# Open ports for http/https/ntp
# 443 is for https
EXPOSE 443
# 80 is for http
EXPOSE 80
# 123 for NTP
EXPOSE 123/UDP

# /start it
CMD ["/sbin/init"]
