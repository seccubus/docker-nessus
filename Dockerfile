# http://tenable.com
# https://index.docker.io/_/centos/
FROM centos:latest

# https://github.com/sometheycallme
MAINTAINER Tim Kropp <timkropp77@gmail.com>

# Install dependencies.
RUN yum -y update \
      nss-util \
      bind-license \
      libssh2 \
    && yum -y install \
      net-tools \
    && yum clean all

# Need Nessus account RPM
# ADD http://downloads.nessus.org/nessus3dl.php?file=Nessus-6.3.7-es6.i386.rpm&licence_accept=yes&t=9bdd4aaf6bb049c9113b8d4287d27d18  /tmp/
# RUN ls -l /tmp
# The above DL will only pull the PHP page (logon wall)
# you need to pull the rpm locally

COPY Nessus-6.4.3-es6.x86_64.rpm /tmp/
# run the yum install twice as workaround for rpmdb checksum error with overlayfs
RUN (yum -y --nogpgcheck localinstall /tmp/Nessus-6.4.3-es6.x86_64.rpm || \
     yum -y --nogpgcheck localinstall /tmp/Nessus-6.4.3-es6.x86_64.rpm) && \
     yum clean all


# Copy Entrypoint
COPY 		entrypoint.sh /

EXPOSE 		8834
VOLUME		[ "/opt/data" ]
ENTRYPOINT 	[ "/entrypoint.sh" ]

