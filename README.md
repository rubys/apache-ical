# Apache ICAL

Ingredients:

- Apache 2.4.52, APR 1.7.0, APR Util 1.6.1 from Ubuntu 22.4 (Jammy)
- mod_dav_access from https://github.com/minfrin/mod_dav_access, which gives webdav ACL access to anyone allowed by httpd.
- mod_dav_calendar from https://github.com/minfrin/mod_dav_calendar, which gives you the calendar itself, and the calendar to iCal feed gateway.
- mod_ical from https://github.com/minfrin/mod_ical, which allows an iCal resource to be filtered or converted to jCal or xCal for display on the web.

Builds from Ubuntu 22.4 and PPA at https://launchpad.net/~minfrin/+archive/ubuntu/apache2/

Build Instructions:


```
git clone https://github.com/rubys/apache-ical.git
cd apache-ical
./build.sh
```

Local testing:

```
docker compose up -d
curl http://localhost/calendar/
curl -u [root-karma] -X MKCALENDAR http://localhost/calendar/members
curl -u [root-karma] -X MKCALENDAR http://localhost/calendar/board
curl -u [root-karma] -X MKCALENDAR http://localhost/calendar/apr
curl -u [members-karma] -H "Depth: 0" -X PROPFIND http://localhost/calendar/members/
curl http://localhost/calendar/members/
docker compose exec web /bin/bash
./gdb.sh
```

Cleanup:

```
docker compose rm -f
docker system prune -f
```

