#!/usr/bin/env bash
#
# Setup script to run after installing Fedora Silverblue and composing custom
# OSTREE image mto-desktop 
# Author: MTO (https://www.mto.nu)


echo "Set hostname to notus"
echo ""
hostnamectl set-hostname notus 
#[notus|boreas|zephyrus|eurus]

echo "Rebase to custom image mto-desktop with remote workstation"
echo ""
if [[ ! -e /etc/ostree/remotes.d/workstation.conf ]]; then
	ostree remote add workstation file:///var/home/mto/workstation_ostree_config/repo --no-gpg-verify
    rpm-ostree rebase workstation:mto-desktop
fi

echo "Install starship"
echo ""
curl -fsSL https://starship.rs/install.sh | bash

echo "Set dotfiles"
echo ""
chezmoi init --apply --verbose https://github.com/mto79/dotfiles.git

echo "Set certificates for duplicati mono (can only be done with flag --user)"
echo ""
cert-sync --user /etc/pki/tls/certs/ca-bundle.crt

echo ""

echo "Flatpak installation"
echo ""
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.spotify.Client -y
#flatpak install flathub com.visualstudio.code -y
flatpak install flathub com.getpostman.Postman -y
#flatpak install flathub org.mozilla.Thunderbird -y
flatpak install flathub org.fedoraproject.MediaWriter -y
flatpak install flathub com.mattermost.Desktop -y
#flatpak install flathub info.mumble.Mumble -y
#flatpak install flathub us.zoom.Zoom -y
#flatpak install flathub com.bluejeans.BlueJeans -y

