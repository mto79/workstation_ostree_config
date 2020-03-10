#!/bin/sh
set -eu
CACHE=/var/cache/ostree
REPO=/var/tmp/repo

mkdir -p $CACHE

if [ ! -d $REPO/objects ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

rpm-ostree compose tree --cachedir=$CACHE --repo=$REPO mto-i3-desktop.yaml