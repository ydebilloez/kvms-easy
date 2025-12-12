#!/bin/bash

touch /var/run/container-initialconfig

# Check if clang is already installed, if not install clang, gcc, git
if ! command -v clang &> /dev/null; then
    echo "Installing development tools..."
    
    dnf --quiet makecache --refresh
    dnf --quiet update -y
    dnf install -y clang clang-tools-extra git glibc-static libstdc++-static
    dnf --quiet clean packages

    echo "Container installation of additional tools finished!"
else
    echo "Container configured earlier!"
fi

touch /var/run/container-initialconfig-ok

exec "$@"