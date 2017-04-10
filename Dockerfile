# -----------------------------------------------------------------------------
# nagios-container
#
# Builds a basic docker image that can run nagios
#
# Authors: Bosman
# Updated: April 7th, 2017
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

# Base system is CentOS 6.8
FROM    centos:centos6
MAINTAINER "Bosman"
ENV container=docker \
	NAGIOS_HOME="/etc/nagios" \
	NAGIOS_USER="nagios" \
	NAGIOS_GROUP="nagios" \
	NAGIOS_CMDUSER="nagios" \
	NAGIOS_CMDGROUP="nagios" \
	NAGIOSADMIN_USER="nagiosadmin" \
	NAGIOSADMIN_PASS="nagios" \
	APACHE_RUN_USER="nagios" \
	APACHE_RUN_GROUP="nagios" \
	NAGIOS_TIMEZONE		MST

# Environment paths
ENV PATH /sbin:/bin:/usr/sbin:/usr/bin

# Lets get the latest patches for CentOS
RUN yum clean all \
	&& yum update -y \
	&& yum install -y

# Install Nagios prereq's and some common stuff (we will get the epel release for the nagios install).
RUN yum install -y \
	httpd \
	mod_ssl \
	yum-utils \
	php \
	php-cli \
	mlocate \
	sendmail \
	crontabs \
	vim-common \
	vim-enhanced \
	mlocate \
	sysstat \
	wget \
	unzip \
	screen \
	ntp \	
	man \
	elinks \
	cronie \
	mtr \
	traceroute \
	nmap \
	ipset \
	bridge-utils \
	perl \
	perl-CGI \
	perl-GD \
	perl-CPAN \
	epel-release 

# Add nagios and apache group and user info
RUN useradd nagios \
	&& groupadd nagcmd \
	&& usermod -a -G nagcmd nagios \
	&& usermod -a -G nagcmd apache

# Get the nagios rpm's
RUN yum-config-manager --enable epel-testing \
	&& yum clean all \
	&& yum install -y nrpe \
	nagios \
	nagios-plugins-all \
	perl-Nagios-Plugin \
	bash-completion \
	pnp4nagios 
RUN yum-config-manager --disable epel-testing

# Create and set the nagios login and password (change this for your custom use - username first then password). 
RUN /usr/bin/htpasswd -c -b /etc/nagios/htpasswd nagiosadmin nagiosadmin

# Fix for docker on Windows and OSX.  I have tested this container on Ubuntu, Centos, Windows 10, and OSX Yosemite.  This fixes oddball behavior in Windows and OSX.
#RUN /bin/mkdir -p /var/run/nagios && /bin/chown nagios:apache /var/run/nagios && /bin/mkdir -p /var/log/nagios && /bin/chown -R nagios:apache /var/log/nagios && /bin/chown -R nagios:apache /etc/nagios

# Start our services
RUN for service in nrpe crond httpd nagios sendmail;do /sbin/service $service start;done

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
