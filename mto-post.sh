#!/usr/bin/env bash
set -xeuo pipefail

# Install local RPMs
#rpm -i --verbose /usr/lib/local-rpms/*.rpm
#rm -rf /usr/lib/local-rpms

# Enable SysRQ
echo 'kernel.sysrq = 1' > /etc/sysctl.d/90-sysrq.conf

# power saving
#echo 'blacklist e1000e' > /etc/modprobe.d/blacklist-local.conf

# NetworkManager config
cat <<EOF > /etc/NetworkManager/conf.d/local.conf
[main]
plugins=

[device]
wifi.backend=iwd
EOF
ln -sfn /usr/lib/systemd/system/systemd-resolved.service /etc/systemd/system/multi-user.target.wants/systemd-resolved.service
ln -sfn /usr/lib/systemd/system/iwd.service /etc/systemd/system/multi-user.target.wants/iwd.service
ln -sfn /run/NetworkManager/resolv.conf /etc/resolv.conf

# X11/DM config
#cat <<EOF > /etc/X11/xorg.conf.d/01-intel.conf
#Section "Device"
#	Identifier "Intel"
#	Driver "intel"
#EndSection
#EOF

# Lock screen on suspend
cat <<EOF > /etc/systemd/system/suspend-lock.service
[Unit]
Description=Lock mto i3 on suspend
Before=sleep.target

[Service]
User=mto
Environment=DISPLAY=:0
#Environment=XAUTHORITY=/run/lxdm/1000/.Xauthority
ExecStart=/usr/bin/i3lock -n

[Install]
WantedBy=sleep.target
EOF
mkdir -p /etc/systemd/system/sleep.target.wants/
ln -sf /etc/systemd/system/suspend-lock.service /etc/systemd/system/sleep.target.wants/suspend-lock.service

# enable other units
ln -s /usr/lib/systemd/system/systemd-timesyncd.service /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service
#ln -s /usr/lib/systemd/system/cockpit.socket /etc/systemd/system/sockets.target.wants/cockpit.socket

# avoid LVM spew in /etc
sed -i 's/backup = 1/backup = 0/; s/archive = 1/archive = 0/' /etc/lvm/lvm.conf

# schroot: use tmpfs for sessions
#echo 'L+ /var/lib/schroot - - - - /run/schroot' > /usr/lib/tmpfiles.d/0-schroot.conf
#echo 'd /run/schroot/session 0755 root root' >> /usr/lib/tmpfiles.d/0-schroot.conf
# schroot: mount home directory
#echo '/var/home /var/home none rw,bind 0 0' >> /etc/schroot/default/fstab

# select preferred vim version
ln -sfn vimx /usr/bin/vim
