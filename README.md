# Scripts
Scripts for various things

**See router/lan/local_hosts for a listing of ips & hosts**

These scripts are written specifically for using joey as the router


## Router
This sets up VTLUUG's router (joey.vtluug.org). ARP/NDP Proxy are required due to port security. Dnsmasq is used for DHCP on our private network and provides SLAAC (+ PTR records???) using the ra-only mode.

- router/ip-config
    - Typical /etc/network/interfaces config for the router
- router/sysctl.conf
    - Sysctl settings for enabling IPv6 privacy extensions and forwarding
- router/firewall
    - firewall rules (TODO)
- router/ipsec
    - ipsec configuration (TODO)
- router/lan
    - dnsmasq & nat configuration
- router/proxy
    - arp proxying

## Libvirt-hosts
Sets up the bridge interfaces on new libvirt hosts. This should be the first thing done after a new installation.

Make sure you change $INTERFACE the interface that is being bridged.
