#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <operation> <docker_path> <save_dir>"
    exit 1
fi

docker_path=$2
save_dir=$3
file_name=$(basename "$docker_path")
host_path="$save_dir/$file_name"

get_copy() {
  mkdir -p "$save_dir"
  backup_path="$host_path.bak"

  if [ ! -f "$host_path" ]; then
      docker compose cp "$docker_path" "$host_path"
  fi

  if [ ! -f "$backup_path" ]; then
      cp "$host_path" "$backup_path"
  fi
  echo -n "$host_path"
}

set_copy() {
  docker compose cp "$host_path" "$docker_path"
}

case "$1" in
    get) get_copy;;
    set) set_copy;;
    *) exit 1;;
esac
