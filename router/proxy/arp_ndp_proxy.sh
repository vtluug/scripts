#!/bin/bash
####################################################################
# arp_ndp_proxy.sh - ipv4 arp and ipv6 proxying for joey.vtluug.org
#
# ./arp_ndp_proxy start      - start ipv4 and ipv6 proxying
# ./arp_ndp_proxy stop       - stop ipv4 and ipv6 proxying
# ./arp_ndp_proxy start ipv4 - start ipv4 proxying
# ./arp_ndp_proxy start ipv6 - start ipv6 proxying
# ./arp_ndp_proxy stop ipv4  - stop ipv4 proxying
# ./arp_ndp_proxy stop ipv6  - stop ipv6 proxying
#
# author: pew <paul@walko.org> (2018-03-26)
####################################################################

# Make sure path is proper
export PATH=/sbin:/usr/sbin:${PATH}

EXT_IF=eth0
INT_IF=eth1

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
')

# Attempt to do an "Unsolicited ARP" to the Burris router
arp_ping_the_router () {
    echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind
    arping -q -I $EXT_IF -U -c 2 -s $1 $ARPING_HOST >&2
    echo 0 > /proc/sys/net/ipv4/ip_nonlocal_bind
}

# Enable flags and add machines
# $1 is {start|stop}
# $2 is [ipv4|ipv6]
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
    if [ "$2" == "ipv4" ] || [ "$2" == "" ]; then
        echo -e "\tConfiguring ipv4 flags"
#        echo $enable > /proc/sys/net/ipv4/conf/$EXT_IF/proxy_arp
#        echo $enable > /proc/sys/net/ipv4/conf/$INT_IF/proxy_arp
#        echo $enable > /proc/sys/net/ipv4/conf/$EXT_IF/forwarding
#        echo $enable > /proc/sys/net/ipv4/conf/$INT_IF/forwarding
    fi
    # Enable ipv6 flags
    if [ "$2" == "ipv6" ] || [ "$2" == "" ]; then
        echo -e "\tConfguring ipv6 flags"
#        echo $enable > /proc/sys/net/ipv6/conf/$EXT_IF/accept_ra
#        echo $enable > /proc/sys/net/ipv6/conf/$INT_IF/accept_ra
#        echo $enable > /proc/sys/net/ipv6/conf/$EXT_IF/forwarding
#        echo $enable > /proc/sys/net/ipv6/conf/$INT_IF/forwarding
#        echo $enable > /proc/sys/net/ipv6/conf/$EXT_IF/proxy_ndp
#        echo $enable > /proc/sys/net/ipv6/conf/$INT_IF/proxy_ndp
    fi
    echo ""

    # Route machines
    echo -e "$action machines:"
    for machine in $MACHINES; do
        # Lookup IPs
        addr4=$(dig $machine +short a | tail -n 1)
        addr6=$(dig $machine +short aaaa | tail -n 1)

        # Add/Del ipv4 machines
        if [ "$2" == "ipv4" ] || [ "$2" == "" ]; then
            if [ -n "$addr4" ]; then
                echo -e "\t$machine \t $addr4"

#                ip route $action $addr4 dev $INT_IF
                # Refresh Burrus's ARP cache
#                arp_ping_the_router $addr4
            else
                echo -e "\tWarning: No A record for $machine" >&2
            fi
        fi
        # Add/Del ipv6 machines
        if [ "$2" == "ipv6" ] || [ "$2" == "" ]; then
            if [ -n "$addr6" ]; then
                echo -e "\t$machine \t $addr6"
                
#                ip -6 route $action $addr6 dev $INT_IF
            else
                echo -e "\tWarning: No AAAA record for $machine" >&2
            fi
        fi
    done
}

# Main routine
case $1 in
    start|stop)
        manage $1 $2
    ;;
    *)
        echo "Usage: $0 {start|stop} [ipv4|ipv6]"
        exit 1
esac