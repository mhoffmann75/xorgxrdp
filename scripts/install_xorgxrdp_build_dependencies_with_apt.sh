#!/bin/sh
set -eufx

if [ -z "${1:-}" ]; then
    # No arch specified
    ARCH=amd64
elif [ "${1#--}" != "$1" ]; then
    # First parameter starts with '--'
    ARCH=amd64
else
    ARCH=$1
    shift
fi

APT_EXTRA_ARGS="$@"

# common build tools for all architectures and feature sets
PACKAGES=" \
    xserver-xorg-core \
    xserver-xorg-dev \
    nasm \
    "

case "$ARCH"
in
    amd64)
        ;;
    i386)
        PACKAGES="$PACKAGES \
            gcc-multilib \
            "
        dpkg --add-architecture i386
        dpkg --print-architecture
        dpkg --print-foreign-architectures
        apt-get update
        ;;
    *)
        echo "unsupported architecture: $ARCH"
        exit 1;
        ;;
esac

apt-get update
apt-get -yq \
    --no-install-suggests \
    --no-install-recommends \
    $APT_EXTRA_ARGS \
    install $PACKAGES
