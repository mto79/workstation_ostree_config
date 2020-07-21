#!/bin/sh
set -eu

CACHE=/var/home/mto/workstation_ostree_config/cache/ostree
REPO=/var/home/mto/workstation_ostree_config/repo

mkdir -p $CACHE
mkdir -p $REPO

#rm -Rf /share/* #test vm
rm -Rf $CACHE/*
rm -Rf $REPO/*

if [ ! -d $REPO/objects ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

rpm-ostree compose tree --cachedir=$CACHE --repo=$REPO mto-desktop.yaml

ostree remote add workstation file:///$REPO --no-gpg-verify

rpm-ostree rebase workstation:mto-desktop
rpm-ostree upgrade

systemctl reboot

#cp -Rfp $REPO/* /share #test vm
