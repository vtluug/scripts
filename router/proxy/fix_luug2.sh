#!/bin/sh

# This scripts prevents other hosts from using luug2.ece.vt.edu

while true; do
	echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind
	arping -q -I eth0 -U -c 2 -s 128.173.89.246 128.173.91.254
	sleep 120
done

#echo 0 > /proc/sys/net/ipv4/ip_nonlocal_bind
