FROM ubuntu:20.04

ARG APACHE=2.4.53
ARG APR=1.7.0
ARG APR_UTIL=1.6.1
ARG MOD_DAV_ACCESS=0.1.0
ARG MOD_DAV_CALENDAR=0.1.0
ARG MOD_ICAL=0.0.8

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    curl \
    gdb \
    libical-dev \
    libjson-c-dev \
  && DEBIAN_FRONTEND=noninteractive apt-get build-dep -y apache2

RUN curl -sL https://downloads.apache.org/httpd/httpd-$APACHE.tar.gz \
  | tar xzC /usr/local/src \
  && curl -sL https://downloads.apache.org/apr/apr-$APR.tar.gz \
  | tar xzC /usr/local/src/httpd-$APACHE/srclib \
  && mv /usr/local/src/httpd-$APACHE/srclib/apr-$APR /usr/local/src/httpd-$APACHE/srclib/apr \
  && curl -sL https://downloads.apache.org//apr/apr-util-$APR_UTIL.tar.gz \
  | tar xzC /usr/local/src/httpd-$APACHE/srclib \
  && mv /usr/local/src/httpd-$APACHE/srclib/apr-util-$APR_UTIL /usr/local/src/httpd-$APACHE/srclib/apr-util \
  && mkdir /opt/apache$APACHE \
  && cd /usr/local/src/httpd-$APACHE \
  && ./configure --prefix=/opt/apache$APACHE --with-included-apr --with-ldap \
  && make \
  && make install

RUN curl -sL https://github.com/minfrin/mod_dav_access/releases/download/mod_dav_access-$MOD_DAV_ACCESS/mod_dav_access-$MOD_DAV_ACCESS.tar.gz \
  | tar xzC /usr/local/src \
  && cd /usr/local/src/mod_dav_access-$MOD_DAV_ACCESS \
  && ./configure --prefix=/opt/apache$APACHE --with-apxs=/opt/apache$APACHE/bin/apxs \
  && make \
  && make install

RUN curl -sL https://github.com/minfrin/mod_dav_calendar/releases/download/mod_dav_calendar-$MOD_DAV_CALENDAR/mod_dav_calendar-$MOD_DAV_CALENDAR.tar.gz \
  | tar xzC /usr/local/src \
  && cd /usr/local/src/mod_dav_calendar-$MOD_DAV_CALENDAR \
  && ./configure --prefix=/opt/apache$APACHE --with-apxs=/opt/apache$APACHE/bin/apxs \
  && make \
  && make install

RUN curl -sL https://github.com/minfrin/mod_ical/releases/download/mod_ical-$MOD_ICAL/mod_ical-$MOD_ICAL.tar.gz \
  | tar xzC /usr/local/src \
  && cd /usr/local/src/mod_ical-$MOD_ICAL \
  && ./configure --prefix=/opt/apache$APACHE --with-apxs=/opt/apache$APACHE/bin/apxs \
  && make \
  && make install

RUN mkdir -p /work/DEBIAN \
  && mkdir -p /work/opt \
  && cp -rp /opt/apache$APACHE /work/opt

COPY control /work/DEBIAN

RUN dpkg-deb --build /work /root/apache-ical.deb

COPY calendar.conf /opt/apache$APACHE/conf/extra

RUN echo "Include conf/extra/calendar.conf" >> /opt/apache$APACHE/conf/httpd.conf \
  && mkdir /opt/apache$APACHE/htdocs/calendar \
  && chown daemon:daemon /opt/apache$APACHE/htdocs/calendar \
  && mkdir /calendar \
  && chown daemon:daemon /calendar

CMD ["/opt/apache2.4.53/bin/apachectl", "-D", "FOREGROUND"]

EXPOSE 80
