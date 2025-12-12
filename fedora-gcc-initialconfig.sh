#!/bin/bash

touch /var/run/container-initialconfig

# Check if clang is already installed, if not install gcc, git
if ! command -v g++ &> /dev/null; then
    echo "Installing development tools..."
    
    dnf --quiet makecache --refresh
    dnf --quiet update -y
    dnf install -y g++ git glibc-static
    dnf install -y glibc-devel.i686 glibc-static.i686
    dnf --quiet clean packages

    echo "Container installation of additional tools finished!"
else
    echo "Container configured earlier!"
fi

touch /var/run/container-initialconfig-ok

exec "$@"
