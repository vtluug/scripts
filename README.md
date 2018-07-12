# Scripts
Scripts for various things

These scripts are written specifically for using joey as the router


## Router
This sets up VTLUUG's router (joey.vtluug.org). ARP/NDP Proxy are required due to port security. Dnsmasq is used for DHCP on our private network and provides SLAAC (+ PTR records???) using the ra-only mode.

- router/ip-config
    - Typical /etc/network/interfaces config for the router
- router/firewall
    - firewall rules (TODO)
- router/ipsec
    - ipsec configuration (TODO)
- router/ipv4
    - Old scripts (TODO: REMOVE)
- router/ipv6
    - ipv6 configuration (TODO: REMOVE)
- router/lan
    - dnsmasq & nat configuration
- router/proxy
    - arp proxying
