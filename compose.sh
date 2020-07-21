#!/bin/sh
set -eu

CACHE=/var/home/mto/workstation_ostree_config/cache/ostree
REPO=/var/home/mto/workstation_ostree_config/repo

mkdir -p $CACHE
mkdir -p $REPO

rm -Rf $CACHE/*
rm -Rf $REPO/*

if [ ! -d $REPO/objects ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

rpm-ostree compose tree --cachedir=$CACHE --repo=$REPO mto-desktop.yaml

ostree remote add workstation file:///$REPO --no-gpg-verify

if [[ ! -e /etc/ostree/remotes.d/workstation.conf ]]; then
    rpm-ostree rebase workstation:mto-desktop
    rpm-ostree upgrade
fi