# -----------------------------------------------------------------------------
# nagios-container
#
# Builds a basic docker image that can run nagios
#
# Authors: Bosman
# Updated: April 6th, 2017
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

# Base system is CentOS 6.8
FROM    centos:centos6
MAINTAINER "Bosman"
ENV container docker
ENV NAGIOS_HOME			/etc/nagios
ENV NAGIOS_USER			nagios
ENV NAGIOS_GROUP		nagios
ENV NAGIOS_CMDUSER		nagios
ENV NAGIOS_CMDGROUP		nagios
ENV NAGIOSADMIN_USER		nagiosadmin
ENV NAGIOSADMIN_PASS		nagios
ENV APACHE_RUN_USER		nagios
ENV APACHE_RUN_GROUP		nagios
ENV NAGIOS_TIMEZONE		MST

# Environment paths
ENV PATH /sbin:/bin:/usr/sbin:/usr/bin

# Lets get the latest patches for CentOS
RUN yum clean all
RUN yum update -y

# Install Nagios prereq's and some common stuff (we will get the epel release for the nagios install).
RUN yum install -y \
	httpd \
	mod_ssl \
	yum-utils \
	php \
	php-cli \
	openssl \
	mlocate \
	sendmail \
	crontabs \
	bash-completion \
	vim-common \
	vim-enhanced \
	mlocate \
	wget \
	unzip \
	curl \
	screen \
	ntp \	
	man \
	elinks \
	wireshark \
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
RUN useradd nagios
RUN groupadd nagcmd
RUN usermod -a -G nagcmd nagios
RUN usermod -a -G nagcmd apache

# Get the nagios rpm's
RUN yum-config-manager --enable epel-testing
RUN yum clean all
RUN yum install -y nrpe \
	nagios \
	nagios-plugins-all \
	perl-Nagios-Plugin \
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
