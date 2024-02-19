#!/bin/bash

LOCAL_CONFIG_FILE="config.php"

CONTAINER_CONFIG_PATH="/var/www/html/config/config.php"

SERVICE_NAME="app"

get_config() {
    echo "Getting the config file from the container..."
    docker compose cp "${SERVICE_NAME}:${CONTAINER_CONFIG_PATH}" "$LOCAL_CONFIG_FILE"
    echo "Config file has been copied to $LOCAL_CONFIG_FILE"
}

set_config() {
    echo "Setting the config file in the container..."
    docker compose cp "$LOCAL_CONFIG_FILE" "${SERVICE_NAME}:${CONTAINER_CONFIG_PATH}"
    docker compose exec "$SERVICE_NAME" chown www-data:www-data "$CONTAINER_CONFIG_PATH"
    echo "Owner of the config file in the container has been set to www-data"
}

case "$1" in
    get) get_config;;
    set) set_config;;
    *) exit 1;;
esac

