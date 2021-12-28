# Gateway Manual Configuration

## Overview
Setup NAT with IP Table rules so the VM acts as a gateway enabling public network access for the LAN.

## Write-up
Provided with a VM containing two network interfaces, ens160 and ens192, ens192 being a wired connection enabling access to the local network; I configured the second network interface, ens160, to use ens192 as a gateway. The other VMs on the network were then able to to connect to outside networks, utilising my machine as a gateway. The configuration files for the network interfaces are located at "/etc/sysconfig/network-scripts/". To begin with, the gateway key in this configuration file was set manually, to the IP of the wired connection. Later, this was configured automatically using DHCP - this involved setting the protocol with ```BOOTPROTO=dhcp```

### Global Network Config
The main network configuration file is located at "/etc/sysconfig/network/", it is a global config file for all NICs. In this, networking is enabled with ```NETWORKING=yes```, ```HOSTNAME=nat``` is set to enable NAT, gateway is set to the wired connection's interface with ```GATEWAY=192.168.1.150```.

### NAT configuration with IP Tables
Configuration of IP Table rules to allow for the NAT system to rewrite destination and source addresses of packets.

First, flush existing firewall rules, then delete rule chains. Then, setup IP forwarding and masquerading (the Linux-specific form of NAT). The commands used are displayed below.

#### Flushing tables:
```
iptables -F

iptables -t nat -F

iptables -t mangle -F
```

#### Deleting tables:
```
iptables -X

iptables -t nat -X

iptables -t mangle -X
```

#### IP forwarding and masquerading
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

iptables -A FORWARD -i eth1 -j ACCEPT
```
The following command enables kernel packet forwarding.
```
echo 1 > /proc/sys/net/ipv4/ip_forward
```
To make this permanent, set it in /etc/sysctl.conf
```
net.ipv4.ip_forward=1
```

#### Apply configuration changes
```
service iptables save

service iptables restart
```

## Post-mortem
Initial VM was setup, statically, as a DHCP server so that the other machines on the subnet could be reached. Later, the DHCP server was setup as a dedicated machine. The DHCP server was used to automatically assign addresses to the other machines. 

DNS server required packages bind and bind-utils, BIND is an acronym for Berkely Internet Name Domain. It's software that performs name to IP conversion. DNS configuration involves creating forward lookup zones for the hostnames, as well as reverse lookup zones. 
Forward lookup zones map hostnames to IP addresses whereas reverse lookup zones map IP addresses to hostnames.