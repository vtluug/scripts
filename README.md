# Scripts
Scripts for various things

## Ldap
I have no idea what this is for. TODO: remove

## router
This sets up VTLUUG's router (temp88191.vtluug.org). ARP/NDP Proxying are requried due to port security.
- ipv4/Nat sets up ARP proxying
- [npd6](http://npd6.github.io/npd6/) in conjunction with ipv6/ndp6.conf to proxy NDP
- ipv6/setup_ipv6.sh to set up IPv6 routes
