FROM centos:6
COPY enable-ius.sh /usr/local/bin/enable-ius.sh
RUN bash /usr/local/bin/enable-ius.sh
RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
RUN rpm -i http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
COPY MariaDB.repo /etc/yum.repos.d/
RUN yum install -y sudo php56u-gd php56u-mbstring php56u-mcrypt php56u-opcache php56u-pdo php56u-pecl-uploadprogress php56u-fpm php56u-redis php56u-soap php56u-mysqlnd httpd mod_fastcgi MariaDB-server
RUN echo "ServerName localhost" >> /etc/httpd/conf.d/servername.conf
RUN sed -i -e 's/FastCgiWrapper On/FastCgiWrapper Off/' /etc/httpd/conf.d/fastcgi.conf
COPY www.php.conf /etc/httpd/conf.d/www.php.conf
# now install Drupal
WORKDIR /var/www/html
# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 7.43
ENV DRUPAL_MD5 c6fb49bc88a6408a985afddac76b9f8b
RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
	&& chown -R php-fpm:php-fpm sites
# Now configure mysql
COPY mysql-secure.sh /usr/local/bin/
# TODO: mysqlrootpass as parameter?
RUN bash /usr/local/bin/mysql-secure.sh mysqlrootpass
# RUN ["service", "php-fpm", "start"] 
# RUN ["service", "httpd", "start"]
# RUN ["service", "mysql", "start"]
# CMD ["tail", "-f", "/var/log/httpd/access_log"]
CMD ["/bin/bash"]
