# Apache ICAL

Ingredients:

- Apache 2.4.53, APR 1.7.0, APR Util 1.6.1
- mod_dav_access from https://github.com/minfrin/mod_dav_access, which gives webdav ACL access to anyone allowed by httpd.
- mod_dav_calendar from https://github.com/minfrin/mod_dav_calendar, which gives you the calendar itself, and the calendar to iCal feed gateway.
- mod_ical from https://github.com/minfrin/mod_ical, which allows an iCal resource to be filtered or converted to jCal or xCal for display on the web.

All build together, producing an installable `.deb` file for Ubuntu 20.04

Build Instructions:


```
git clone https://github.com/rubys/apache-ical.git
cd apache-ical
./build.sh
```

Local testing:

```
docker compose up -d
curl http://localhost:3000/
curl -X PROPFIND http://localhost:3000/calendar/board
docker compose exec web /bin/bash
```

Cleanup:

```
docker compose rm -f
docker system prune -f
```

