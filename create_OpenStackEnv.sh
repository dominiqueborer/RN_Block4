#!/bin/bash
#nova keypair-add --pub-key ~/.ssh/id_rsa.pub pitop

get_floating_ip() {
  openstack ip floating list -f value -c "Floating IP Address" -c Port | grep 'None'  | head -1 | cut -f1 -d" "
}

neutron net-create --port_security_enabled=False  Net1

neutron net-create --port_security_enabled=False  Net100

neutron net-create --port_security_enabled=False  Net101

neutron net-create --port_security_enabled=False  Net102

neutron net-create --port_security_enabled=False  Net2

neutron net-create --port_security_enabled=False  Net3


neutron port-create --name Net1_PC1 Net1
neutron port-create --name Net1_R1 Net1
neutron port-create --name Net100_R1 Net100
neutron port-create --name Net100_R2 Net100
neutron port-create --name Net101_R1 Net101
neutron port-create --name Net101_R3 Net101
neutron port-create --name Net102_R2 Net102
neutron port-create --name Net102_R3 Net102
neutron port-create --name Net2_R2 Net2
neutron port-create --name Net2_PC2 Net2
neutron port-create --name Net3_R3 Net3
neutron port-create --name Net3_PC3 Net3


nova boot --flavor c1.micro --image "Debian Jessie 8 (SWITCHengines)" \
  --key-name=pitop --nic net-name=private --poll PC1 &

nova boot --flavor c1.micro --image "Debian Jessie 8 (SWITCHengines)" \
  --key-name=pitop --nic net-name=private --poll R1 & 

nova boot --flavor c1.micro --image "Debian Jessie 8 (SWITCHengines)" \
  --key-name=pitop --nic net-name=private --poll R2 &

nova boot --flavor c1.micro --image "Debian Jessie 8 (SWITCHengines)" \
  --key-name=pitop --nic net-name=private --poll R3 &

nova boot --flavor c1.micro --image "Debian Jessie 8 (SWITCHengines)" \
  --key-name=pitop --nic net-name=private --poll PC2 &

nova boot --flavor c1.micro --image "Debian Jessie 8 (SWITCHengines)" \
  --key-name=pitop --nic net-name=private --poll PC3 &

sleep 30

nova interface-attach --port-id $(neutron port-show -F id -f value Net1_PC1) PC1

nova interface-attach --port-id $(neutron port-show -F id -f value Net1_R1) R1
nova interface-attach --port-id $(neutron port-show -F id -f value Net100_R1) R1
nova interface-attach --port-id $(neutron port-show -F id -f value Net101_R1) R1

nova interface-attach --port-id $(neutron port-show -F id -f value Net100_R2) R2
nova interface-attach --port-id $(neutron port-show -F id -f value Net102_R2) R2
nova interface-attach --port-id $(neutron port-show -F id -f value Net2_R2) R2

nova interface-attach --port-id $(neutron port-show -F id -f value Net101_R3) R3
nova interface-attach --port-id $(neutron port-show -F id -f value Net102_R3) R3
nova interface-attach --port-id $(neutron port-show -F id -f value Net3_R3) R3

nova interface-attach --port-id $(neutron port-show -F id -f value Net2_PC2) PC2

nova interface-attach --port-id $(neutron port-show -F id -f value Net3_PC3) PC3



openstack ip floating add $(get_floating_ip) R1
openstack ip floating add $(get_floating_ip) R2
openstack ip floating add $(get_floating_ip) R3
openstack ip floating add $(get_floating_ip) PC1
openstack ip floating add $(get_floating_ip) PC2
openstack ip floating add $(get_floating_ip) PC3
