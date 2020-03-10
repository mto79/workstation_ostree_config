#!/usr/bin/env bash
set -xeuo pipefail

# Install local RPM's
rpm -i --verbose /usr/lib/local-rpms/*.rpm
rm -rf /usr/lib/local-rpms

# Enable SysRQ
echo 'kernel.sysrq = 1' > /etc/sysctl.d/90-sysrq.conf

# NetworkManager config
cat <<EOF > /etc/NetworkManager/conf.d/local.conf
[main]
plugins=
dns=dnsmasq
dhcp=internal
EOF

# X11/DM config
cat <<EOF > /etc/X11/xorg.conf.d/01-intel.conf
Section "Device"
	Identifier "Intel"
	Driver "intel"
EndSection
EOF

# Lock screen on suspend
cat <<EOF > /etc/systemd/system/suspend-lock.service
[Unit]
Description=Lock mto i3 on suspend
Before=sleep.target

[Service]
User=mto
Environment=DISPLAY=:0
ExecStart=/usr/bin/i3lock -n

[Install]
WantedBy=sleep.target
EOF
mkdir -p /etc/systemd/system/sleep.target.wants/
ln -sf /etc/systemd/system/suspend-lock.service /etc/systemd/system/sleep.target.wants/suspend-lock.service

# schroot: use tmpfs for sessions
#echo 'L+ /var/lib/schroot - - - - /run/schroot' > /usr/lib/tmpfiles.d/0-schroot.conf
#echo 'd /run/schroot/session 0755 root root' >> /usr/lib/tmpfiles.d/0-schroot.conf
# schroot: mount home directory
#echo '/var/home /var/home none rw,bind 0 0' >> /etc/schroot/default/fstab