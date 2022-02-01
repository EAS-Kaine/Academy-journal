# Chef task

## Overview
Utilising Chef, automate the configuration of a network. A virtual machine should serve as a DHCP server,  another for DNS and a gateway to route traffic from the subnet. Encapsulating the configuration of these components, a master script that calls the necessary chef recipes and, lastly, starts node apps on each machine. This task we were restricted to only using chef client.

## Write-up
First, I created a chef-repo to encapsulate the chef cookbooks produced for configuring each component. This repository was synchronised using git as version control, enabling the development of components in separate branches.

Passing the berks flag when generating cookbooks allows for dependency management with [Berkshelf](https://docs.chef.io/workstation/berkshelf/); this simplifies using community cookbooks and ensures the selection of the correct cookbook versions. Though [Policyfiles](https://docs.chef.io/policyfile/) facilitate safer workflows, this is something to look into further. 

### DHCP server

Configuration of the DHCP server consisted of using a [community cookbook](https://supermarket.chef.io/cookbooks/dhcp), maintained by Sous-Chefs, to install and configure the DHCP server after supplying the configuration values in the eas-dhcp cookbook I created as a wrapper. As well as the [resolver cookbook](https://supermarket.chef.io/cookbooks/resolver), also maintained by Sous-Chefs, to configure the ```/etc/resolv.conf``` file using the attributes I supplied.

### /etc/resolv.conf
Below is the code block for using the resolver cookbook, with my supplied values.
```
resolver_config "/etc/resolv.conf" do
  nameservers ["10.0.0.13, 8.8.8.8, 8.8.4.4"]
  domain "easlab.local"
  search ["easlab.local"]
  options(
    "timeout" => 2,
  )
end
```
Statically setting this configuration is necessary because the DHCP protocol supplies information to the clients but not itself.

### Package installation
Below is a code block that utilises the chef package [resource](https://docs.chef.io/resources/package/) to install the ```dhcp-server ``` package.
```
package "dhcp-server" do
  action [:install]
  flush_cache [:before]
end
```

### DHCP configuration
Below is the code block responsible for starting the DHCP service daemon.
```
dhcp_service "dhcpd" do
  ip_version :ipv4
  action :nothing
end
```
Initially, the block above does nothing; the block below starts the DHCP service immediately after configuring the subnet. 
```
dhcp_subnet "10.0.0.0" do
  comment "Basic Subnet Declaration"
  subnet "10.0.0.0"
  netmask "255.255.255.0"
  options [
            "routers 10.0.0.12",
          ]
  pools(
    "range" => "10.0.0.1 10.0.0.50",
  )
  parameters(
    "ddns-domainname" => '"easlab.local"',
  )
  notifies :start, "dhcp_service[dhcpd]", :immediately
end
```
Above is the configuration of the subnet.
```
dhcp_host "DNS" do
  options "host-name" => "DNS"
  identifier "hardware ethernet 00:50:56:b2:34:94"
  address "10.0.0.13"
end

dhcp_host "dhcp" do
  identifier "hardware ethernet 00:50:56:b2:34:94"
  address "10.0.0.2"
  options(
    "host-name" => "dhcp",
  )
end

dhcp_host "Gateway" do
  options "host-name" => "Gateway"
  identifier "hardware ethernet 00:50:56:AF:3A:29"
  address "10.0.0.12"
end
```
Above is the code block for host declarations; it assigns hosts an address and hostname using the machine's mac address.

## Post-mortem
