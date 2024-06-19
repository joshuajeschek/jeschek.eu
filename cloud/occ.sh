#!/bin/bash

docker compose exec -u 82 app ./occ "$@"
