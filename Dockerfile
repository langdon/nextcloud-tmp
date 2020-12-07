FROM ubi8/php-74

USER root
RUN yum -y install php-gd php-xml \
                   php-mbstring php-intl php-pecl-apcu php-mysqlnd \
                   php-opcache php-json php-zip procps less && \
    yum clean all

USER default
# Add application sources
# for some reason this is being added as root
ADD https://download.nextcloud.com/server/releases/nextcloud-20.0.2.tar.bz2 /tmp/
RUN ls -l /tmp/
USER root
RUN chown default /tmp/nextcloud-20.0.2.tar.bz2
USER default
#back to real user
RUN tar -C /tmp/ -xf /tmp/nextcloud-20.0.2.tar.bz2
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
