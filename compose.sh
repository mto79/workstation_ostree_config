#!/bin/sh
set -eu
CACHE=/home/mto/Development/MTO/workstation_ostree_config/cache/ostree
REPO=/home/mto/Development/MTO/workstation_ostree_config/repo

mkdir -p $CACHE

if [ ! -d $REPO/objects ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

rpm-ostree compose tree --cachedir=$CACHE --repo=$REPO mto-desktop.yaml
