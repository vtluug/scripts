#!/bin/bash
#set -x

protocols_to_block="ftp-data ftp telnet dns kerberos pop2 pop3 sunrpc  ms-rpc netbios-ns netbios-dgm netbios-ssn snmp snmptrap imap3 ldap microsoft-ds kpasswd printer ipp ldaps kerberos-adm kerberos-iv samba-swat pop3s nfs  mysql rdp  krb524 postgres"
protocols_to_block="20       21  23     52  88       109  110  111     135    137        138         139         161  162      220   389  445          464     515     631 636   749          750         901        995   2049 3306  3389 4444   5432"


valid_ranges='
    128.173.0.0/16
    198.82.0.0/16

    10.0.0.0/8
    172.16.0.0/12
    192.168.0.0/16

    198.18.0.0/15
    198.51.100.0/24

    127.0.0.0/8
'

if [[ ${1} = "start" ]] ; then

    /sbin/iptables --new-chain REFLECTION_source
    /sbin/iptables --new-chain REFLECTION_destination

    for range in ${valid_ranges} ; do
        /sbin/iptables --append REFLECTION_source --source ${range} --jump REFLECTION_destination
    done
    /sbin/iptables --append REFLECTION_source                       --jump DROP

    for range in ${valid_ranges} ; do
        /sbin/iptables --append REFLECTION_destination --destination ${range} --jump ACCEPT
    done
    /sbin/iptables --append REFLECTION_destination                            --jump DROP

    for p in ${protocols_to_block} ; do
        /sbin/iptables --insert INPUT   1 --protocol TCP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --insert OUTPUT  1 --protocol TCP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --insert FORWARD 1 --protocol TCP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --insert INPUT   1 --protocol UDP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --insert OUTPUT  1 --protocol UDP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --insert FORWARD 1 --protocol UDP --destination-port ${p} --jump REFLECTION_source
    done

elif [[ ${1} = "stop" ]] ; then

    for p in ${protocols_to_block} ; do
        /sbin/iptables --delete INPUT   --protocol TCP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --delete OUTPUT  --protocol TCP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --delete FORWARD --protocol TCP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --delete INPUT   --protocol UDP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --delete OUTPUT  --protocol UDP --destination-port ${p} --jump REFLECTION_source
        /sbin/iptables --delete FORWARD --protocol UDP --destination-port ${p} --jump REFLECTION_source
    done

    for range in ${valid_ranges} ; do
        /sbin/iptables --delete REFLECTION_destination --destination ${range} --jump ACCEPT
    done
    /sbin/iptables --delete REFLECTION_destination                            --jump DROP

    for range in ${valid_ranges} ; do
        /sbin/iptables --delete REFLECTION_source --source ${range} --jump REFLECTION_destination
    done
    /sbin/iptables --delete REFLECTION_source                       --jump DROP

    /sbin/iptables --delete-chain REFLECTION_source
    /sbin/iptables --delete-chain REFLECTION_destination
else
    echo "Usage: ${0} [start|stop]"
fi
