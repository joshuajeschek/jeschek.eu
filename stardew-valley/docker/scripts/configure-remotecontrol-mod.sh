#!/bin/sh

# Quit if we don't have any default admins
if [ -z "${REMOTE_CONTROL_DEFAULT_ADMINS}" ] || [ ! -f "/data/Stardew/game/Mods/RemoteControl/config.json" ]; then
    return
fi

# Add default admins to the admin list
jq ".admins[.admins | length] |= . + ${REMOTE_CONTROL_DEFAULT_ADMINS}" "/data/Stardew/game/Mods/RemoteControl/config.json" > "/data/Stardew/game/Mods/RemoteControl/config.json.out"
mv -f "/data/Stardew/game/Mods/RemoteControl/config.json.out" "/data/Stardew/game/Mods/RemoteControl/config.json"
