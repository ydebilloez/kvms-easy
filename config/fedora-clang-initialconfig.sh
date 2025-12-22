#!/bin/bash

touch /var/run/container-initialconfig

DNF=dnf
if ! command -v dnf &> /dev/null; then
    # replace dnf by microdnf for older fedora releases
    DNF=microdnf
    echo "Using microdnf for package management"
else
    echo "Using dnf for package management"
fi

# Check if clang is already installed, if not install clang, gcc, git
if ! command -v clang &> /dev/null; then
    echo "Installing development tools..."
    
    $DNF --quiet makecache --refresh
    $DNF --quiet update -y
    $DNF --quiet install -y clang clang-tools-extra git glibc-static libstdc++-static
    $DNF --quiet clean packages

    echo "Container installation of additional tools finished!"
else
    echo "Container configured earlier!"
fi

touch /var/run/container-initialconfig-ok

exec "$@"