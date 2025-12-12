#!/bin/bash

touch /var/run/container-initialconfig

# Check if samba server is alreayd installed
if ! command -v samba &> /dev/null; then
    echo "Installing samba server..."
    

    echo "Container installation of samba server finished!"
else
    echo "Container configured earlier!"
fi

touch /var/run/container-initialconfig-ok


exec "$@"
