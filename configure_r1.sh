#!/bin/bash
apt-get update
apt-get upgrade -y
apt-get -y install vim inetutils-ping tcpdump
apt-get -y install quagga quagga-doc traceroute
cp /usr/share/doc/quagga/examples/zebra.conf.sample /etc/quagga/zebra.conf
cp /usr/share/doc/quagga/examples/ospfd.conf.sample /etc/quagga/ospfd.conf
chown quagga.quaggavty /etc/quagga/*.conf
chmod 640 /etc/quagga/*.conf
sed -i s'/zebra=no/zebra=yes/' /etc/quagga/daemons
sed -i s'/ospfd=no/ospfd=yes/' /etc/quagga/daemons
echo 'VTYSH_PAGER=more' >>/etc/environment
echo 'export VTYSH_PAGER=more' >>/etc/bash.bashrc
cat >> /etc/quagga/ospfd.conf << EOF
interface eth1
interface eth2
interface eth3
interface lo
router ospf
passive-interface eth1
network 192.168.1.0/24 area 0.0.0.0
network 192.168.100.0/24 area 0.0.0.0
network 192.168.101.0/24 area 0.0.0.0
line vty
EOF

cat >> /etc/quagga/zebra.conf << EOF
interface eth1
ip address 192.168.1.254/24
ipv6 nd suppress-ra
interface eth2
ip address 192.168.100.1/24
ipv6 nd suppress-ra
interface eth3
ip address 192.168.101.2/24
ipv6 nd suppress-ra
interface lo
ip forwarding
line vty
EOF
/etc/init.d/quagga restart
