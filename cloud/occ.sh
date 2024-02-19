#!/bin/bash

docker compose exec -u www-data app ./occ "$@"
