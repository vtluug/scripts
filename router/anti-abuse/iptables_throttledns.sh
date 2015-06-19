#!/bin/sh
iptables -A FORWARD -p udp -m state --state NEW -m udp --dport 53 -j ACCEPT
iptables -A FORWARD -p udp -m hashlimit --hashlimit-srcmask 24 \
	 --hashlimit-mode srcip --hashlimit-upto 30/m --hashlimit-burst 10 \
	 --hashlimit-name DNSTHROTTLE --dport 53 -j ACCEPT
iptables -A FORWARD -p udp -m udp --dport 53 -j DROP
