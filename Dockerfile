FROM registry.access.redhat.com/ubi8

USER root

RUN yum install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-repos-8.2-2.2004.0.1.el8.x86_64.rpm

RUN echo "priority=150" >> /etc/yum.repos.d/CentOS-BaseOS.repo

RUN yum -y install mariadb mariadb-server httpd php php-gd php-xml \
                   php-mbstring php-intl php-pecl-apcu php-mysqlnd \
                   php-opcache php-json php-zip procps less && \
    yum clean all

ADD nextcloud.conf /etc/httpd/conf.d/nextcloud.conf
ADD initcont.sh /root/initcont.sh
ADD initmdb.sh /root/initmdb.sh

RUN chmod +x /root/initcont.sh && \
    chmod +x /root/initmdb.sh && \
    sed -i 's/max_execution_time = 30/max_execution_time = 120/' /etc/php.ini && \
    systemctl enable mariadb httpd

EXPOSE 80

CMD [ "/sbin/init" ]
