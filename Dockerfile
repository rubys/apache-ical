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

RUN openssl s_client -connect ldap-us-ro.apache.org:636 -showcerts </dev/null |\
  awk '/BEGIN CERTIFICATE/{p++}{if(p==3){print}}/END CERTIFICATE/{p++}' |\
  > /etc/ssl/certs/asf_root.pem

COPY calendar.conf /etc/apache2/conf-available

RUN a2enmod socache_shmcb ssl ldap dav dav_fs authnz_ldap \
  && a2enconf calendar \
  && mkdir /var/www/html/calendar \
  && chown www-data:www-data /var/www/html/calendar \
  && mkdir /var/www/html/principals \
  && mkdir /calendar \
  && chown www-data:www-data /calendar

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

EXPOSE 80
