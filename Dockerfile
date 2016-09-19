FROM centos:6
COPY enable-ius.sh /usr/local/bin/enable-ius.sh
RUN bash /usr/local/bin/enable-ius.sh
RUN yum install -y sudo php56u-gd php56u-mbstring php56u-mcrypt php56u-opcache php56u-pdo php56u-pecl-uploadprogress php56u-fpm php56u-redis php56u-soap php56u-mysqlnd httpd
RUN echo "ServerName localhost" >> /etc/httpd/conf.d/servername.conf
# manually install+configure mod_fastcgi, dag's repo no longer maintained
RUN rpm -i http://mirror.cpsc.ucalgary.ca/mirror/dag/redhat/el6/en/x86_64/rpmforge/RPMS/mod_fastcgi-2.4.6-2.el6.rf.x86_64.rpm
RUN sed -i -e 's/FastCgiWrapper On/FastCgiWrapper Off/' /etc/httpd/conf.d/fastcgi.conf
COPY www.php.conf /etc/httpd/conf.d/www.php.conf
# now install Drupal
# WORKDIR /var/www/html
# https://www.drupal.org/node/3060/release
# ENV DRUPAL_VERSION 7.43
# ENV DRUPAL_MD5 c6fb49bc88a6408a985afddac76b9f8b
#RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
#	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
#	&& tar -xz --strip-components=1 -f drupal.tar.gz \
#	&& rm drupal.tar.gz \
#	&& chown -R php-fpm:php-fpm sites
# Todo:
# access to host mysql
# configuration
CMD ["/bin/bash"]
