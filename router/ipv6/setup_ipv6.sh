#!/bin/bash
################################################################################
# ipv6_setup.sh - ipv6 proxy ndp setup for temp88191.ece.vt.edu
#
# author: mutantmonkey <mutantmonkey@mutantmonkey.in> (2011-09-27)
################################################################################

######################################################
# XXX: WARNING
######################################################
# this only handles routing, not neighbor proxying
# for that edit /etc/npd6.conf

ext_if=eth0
int_if=eth1

ext_ip=2001:468:c80:6103:211:43ff:fe30:a72
router_ip=fe80::2d0:1ff:feab:a800

# static ARP
arp -s 128.173.88.1 00:d0:01:ab:a8:00
ip -6 neigh add fe80::2d0:1ff:feab:a800 dev $ext_if lladdr 00:d0:01:ab:a8:00 permanent

MACHINES=('
acidburn.vtluug.org
akhaten.ipv6.hazinski.net
blade.vtluug.org
cerealkiller.vtluug.org
crashoverride.vtluug.org
lordnikon.vtluug.org
milton.vtluug.org
ns1.vtluug.org
theplague.vtluug.org
wood.vtluug.org
cyberdelia.vtluug.org
mirror.ece.vt.edu
tardis.vtluug.org
')

# XXX: remember to edit /etc/npd6.conf

# firewall {{{
ip6tables -P FORWARD ACCEPT
ip6tables -F FORWARD
ip6tables -A FORWARD -p tcp --dport 389 -j DROP
ip6tables -A FORWARD -p udp --dport 514 -j DROP
ip6tables -A FORWARD -p tcp --dport 636 -j DROP
ip6tables -A FORWARD -p tcp --dport 3306 -j DROP
ip6tables -A FORWARD -p tcp --dport 5432 -j DROP
ip6tables -A FORWARD -p tcp --dport 5666 -j DROP
ip6tables -A FORWARD -p tcp --dport 11211 -j DROP
ip6tables -A FORWARD -p udp --dport 11211 -j DROP
ip6tables -A FORWARD -p tcp --dport 27017 -j DROP
ip6tables -A FORWARD -p tcp --dport 28017 -j DROP
# }}}

sysctl -w net.ipv6.conf.$ext_if.accept_ra=0
sysctl -w net.ipv6.conf.$int_if.accept_ra=0
sysctl -w net.ipv6.conf.$ext_if.forwarding=1
sysctl -w net.ipv6.conf.$int_if.forwarding=1
sysctl -w net.ipv6.conf.$ext_if.proxy_ndp=1
sysctl -w net.ipv6.conf.$int_if.proxy_ndp=1

ip link set $ext_if promisc on
ip -6 addr add $ext_ip dev $ext_if
ip -6 route add default via $router_ip dev $ext_if metric 512
#ip -6 neigh add proxy $ext_ip dev $int_if

ip -6 addr add  2001:468:c80:6103:aa17::1/80 dev eth1
#ip -6 route add 2001:468:c80:6103:aa17:beef::/96 dev eth1 metric 1

function add_machine {
	ADDR4=$(dig $1 +short a)
	ADDR6=$(dig $1 +short aaaa)

	echo -e "***\t$1"

	# IPv4: Proxy ARP
	if [ -n "$ADDR4" ]; then
		echo -e "\t$ADDR4: No support for IPv4 yet"
		#echo -e "\t$ADDR4"
		#ip -4 route add $ADDR4 dev $int_if
	#else
	#	echo -e "\tWarning: No A record; no IPv4 address added"
	fi

	# IPv6: Proxy NDP
	if [ -n "$ADDR6" ]; then
		echo -e "\t$ADDR6"
		#ip -6 neigh add proxy $ADDR6 dev $ext_if
		ip -6 route del $ADDR6 dev $int_if metric 0
		ip -6 route add $ADDR6 dev $int_if metric 0
	else
		echo -e "\tWarning: No AAAA record; no IPv6 address added"
	fi

	echo ""
}

for machine in $MACHINES; do
	add_machine $machine
done
