FROM ubuntu:22.04

RUN apt-get update \
  && apt-get install -y software-properties-common \
  && add-apt-repository ppa:minfrin/apache2 \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    libapache2-mod-dav-access \
    libapache2-mod-dav-calendar \
     libapache2-mod-ical 

COPY calendar.conf /etc/apache2/conf-available

RUN a2enmod ldap dav dav_fs authnz_ldap \
  && a2enconf calendar \
  && mkdir /var/www/html/calendar \
  && chown www-data:www-data /var/www/html/calendar \
  && mkdir /calendar \
  && chown www-data:www-data /calendar

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

EXPOSE 80
