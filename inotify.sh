#!/usr/bin/with-contenv bash
echo >&2 "starting watcher"

inotifywait -qrme modify,move,create,delete /etc/openresty | while read EVENT; do
    echo $EVENT
    openresty -t
    if [ $? -eq 0 ]; then
        echo "[$(date -Iseconds)] Reloading Openresty Configuration"
        openresty -s reload
    fi
done