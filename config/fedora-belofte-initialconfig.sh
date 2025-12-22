#!/bin/bash

touch /var/run/container-initialconfig

# Check if clang is already installed, if not install clang, gcc, git
if ! command -v clang &> /dev/null; then
    echo "Installing development tools..."
    
    dnf --quiet makecache --refresh
    dnf --quiet update -y

    dnf --quiet install -y git
    # install clang and gcc
    dnf --quiet install -y clang clang-tools-extra glibc-static libstdc++-static
    # gcc 32 bit support
    dnf --quiet install -y glibc-devel.i686 glibc-static.i686
    # clang 32 bit support
    dnf --quiet install -y libstdc++-static.i686 libstdc++-devel.i686
    # install cross compiler
    dnf --quiet install -y mingw32-gcc mingw32-gcc-c++ mingw64-gcc mingw64-gcc-c++ mingw32-winpthreads-static mingw64-winpthreads-static
    # install doxygen
    dnf --quiet install -y doxygen
    # install cppcheck
    dnf --quiet install -y cppcheck

    dnf --quiet clean packages

    echo "Container installation of additional tools finished!"
else
    echo "Container configured earlier!"
fi

touch /var/run/container-initialconfig-ok

exec "$@"