FROM registry.access.redhat.com/ubi8/php-74

RUN whoami
RUN id
RUN ls -l /tmp/ || :
RUN ls -l /tmp/nextcloud || :
RUN ls -l /opt/app-root/src || :
RUN pwd
RUN echo $HOME

#USER root
RUN yum -y install php-gd php-xml \
                   php-mbstring php-intl php-pecl-apcu php-mysqlnd \
                   php-opcache php-json php-zip procps less && \
    yum clean all

#USER 1000
# Add application sources
# for some reason this is being added as root
ADD ./nextcloud-20.0.2.tar.xz /tmp/
RUN ls -l /tmp/ || :
RUN ls -l /tmp/nextcloud || :
RUN ls -l /opt/app-root/src || :

#USER root
#RUN chown -R 1001 /tmp/nextcloud
#back to real user
#USER 1001
# gotta get those pesky .htaccess files
RUN shopt -s dotglob && mv /tmp/nextcloud/* ./

# Run script uses standard ways to configure the PHP application
# and execs httpd -D FOREGROUND at the end
# See more in <version>/s2i/bin/run in this repository.
# Shortly what the run script does: The httpd daemon and php needs to be
# configured, so this script prepares the configuration based on the container
# parameters (e.g. available memory) and puts the configuration files into
# the approriate places.
# This can obviously be done differently, and in that case, the final CMD
# should be set to "CMD httpd -D FOREGROUND" instead.
CMD /usr/libexec/s2i/run
