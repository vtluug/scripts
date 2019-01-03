# Scripts
Scripts for various things

**See router/lan/local_hosts for a listing of ips & hosts**

These scripts are written specifically for using joey as the router

Setup instructions can be found at vtluug.org/rtfm.txt


## Router
Configuration for VTLUUG's router (joey.vtluug.org). ARP/NDP Proxy are required due to port security. Dnsmasq is used for DHCP on our private network and provides SLAAC (+ PTR records???) using the ra-only mode.

- router/ip-config
    - typical /etc/network/interfaces config for the router
- router/ipsec
    - ipsec configuration (TODO)
- router/iptables
    - Router iptables rules
- router/lan
    - dnsmasq & nat configuration
- router/proxy
    - arp proxying
- router/sysctl.conf
    - sysctl settings for enabling IPv6 privacy extensions and forwarding


## Libvirt-hosts
Sets up the bridge interfaces on new libvirt hosts. This should be the first thing done after a new installation.

Make sure you change $INTERFACE the interface that is being bridged.


## Automation
Wiki, website, and other scripts for automating things.


## h200-files
These files are for flashing a Dell H200 raid controller to HBA mode, which enables it to be a "dumb" adapter and not use Dell's typical fimware.
