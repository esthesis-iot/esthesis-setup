#!/usr/bin/env bash

PLATFORM_PORT=1080 \
CHRONOGRAF_PORT=1081 \
docker stack deploy -c docker-compose.yml esthesis-greece
