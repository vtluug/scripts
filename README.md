# scripts
Scripts for the router, etc

## Router scripts
These are scripts for VTLUUG's router (luugtemp.ece.vt.edu). The ones curretly
in use are:
- ipv4/Nat to set ARP proxing (required for CNS ports due to port security)
- [npd6](http://npd6.github.io/npd6/) in conjunction with ipv6/npd6.conf to
  proxy NDP (required for CNS ports due to port security)
- ipv6/setup_ipv6.sh to set IPv6 routes
