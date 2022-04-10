#!/usr/bin/env sh
docker compose build &&
  docker cp $(docker create --rm apache-ical_web:latest):/root/apache-ical.deb .
