#!/bin/bash
####################################################################
# arp_proxy.sh - ipv4 arp proxying vtluug
#
# ./arp_proxy start      - start ipv4 proxying
# ./arp_proxy stop       - stop ipv4 proxying
#
# author: pew <paul@walko.org> (2018-03-26)
####################################################################

# Make sure path is proper
export PATH=/sbin:/usr/sbin:${PATH}

# Set interfaces
EXT_IF=enp2s0
INT_IF=enp4s0

ARPING_HOST=128.173.88.1

# Machines being proxied
# Should be same as https://vtluug.org/wiki/Infrastructure:Network
# luug4 is used instead of mjh bc mjh doesn't work
MACHINES=('
sczi.vtluug.org
cyberdelia.vtluug.org
acidburn.vtluug.org
razor.vtluug.org
luug4.ece.vt.edu
luug5.ece.vt.edu
')

# Attempt to do an "Unsolicited ARP" to the Burris router
arp_ping_the_router () {
    echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind
    arping -q -I $EXT_IF -U -c 2 -s $1 $ARPING_HOST >&2
    echo 0 > /proc/sys/net/ipv4/ip_nonlocal_bind
}

# Enable flags and add machines
# $1 is {start|stop}
manage () {
    # Set start/stop variables
    # Since starting/stoping are very similar commands these variables set the
    #   few needed variables accordingly (instead of having 2 separate
    #   functions that do 95% the same thing)
    enable=1
    action="add"
    if [ "$1" == "stop" ]; then
        enable=0
        action="delete"
    fi

    # Enable ipv4 flags
    echo -e "$action flags:"
    echo -e "\tConfiguring ipv4 flags"
    echo $enable > /proc/sys/net/ipv4/conf/$EXT_IF/proxy_arp
    echo $enable > /proc/sys/net/ipv4/conf/$INT_IF/proxy_arp
    echo $enable > /proc/sys/net/ipv4/conf/$EXT_IF/forwarding
    echo $enable > /proc/sys/net/ipv4/conf/$INT_IF/forwarding
    echo ""

    # Route machines
    echo -e "$action machines:"
    for machine in $MACHINES; do
        # Lookup IPs
        addr4=$(dig $machine +short a | tail -n 1)

        # Add/Del machines
        if [ -n "$addr4" ]; then
            echo -e "\t$machine \t $addr4"

            ip route $action $addr4 dev $INT_IF
            # Refresh Burrus's ARP cache
            arp_ping_the_router $addr4
        else
            echo -e "\tWarning: No A record for $machine" >&2
        fi
    done
}

# Main routine
case $1 in
    start|stop)
        manage $1
    ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
esac

# TEMP TODO
sysctl -w net.ipv6.conf.all.proxy_ndp=1
for machine in $MACHINES; do
    addr6=$(dig $machine +short aaaa | tail -n 1)
    if [ -n "$addr6" ]; then
        ip -6 neigh add proxy $addr6 dev enp2s0
    fi
done
