#!/bin/bash
apt-get update
apt-get upgrade -y
apt-get -y install vim inetutils-ping tcpdump traceroute
cat > /etc/network/interfaces.d/eth1 << EOF
auto eth1
iface eth1 inet static
address 192.168.2.1
netmask 255.255.255.0
up route add -net 192.168.0.0/16 gw 192.168.2.254 dev eth1
EOF
/etc/init.d/networking restart
