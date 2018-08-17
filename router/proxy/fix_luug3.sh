#!/bin/sh

while true; do
	echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind
	arping -q -I eth0 -U -c 2 -s 128.173.89.247 128.173.91.254
	sleep 2
done

#echo 0 > /proc/sys/net/ipv4/ip_nonlocal_bind
