#!/bin/bash
# Block recursive DNS abusers

IPS=(208.110.65.133  # sent abuse complaint about DNS reflection attacks
     70.39.100.103
     198.105.222.118
     178.33.217.9
     23.29.114.162
     70.39.77.25
     178.33.217.13
     37.59.240.162
     178.32.36.49
     46.105.118.154
     5.39.8.30
     88.231.32.180
     78.46.40.112
     5.135.100.90
     184.95.63.51
     184.164.154.226
     69.197.38.114
     178.33.217.9
     206.190.136.254
     184.164.154.226
     178.238.229.78
     188.95.48.173
     188.138.122.111
     199.189.87.51
     198.12.15.86
     207.20.33.240
     195.210.5.19
     173.246.97.2   # a.dns.gandi.net
     217.70.184.40  # b.dns.gandi.net
     217.70.182.20  # c.dns.gandi.net
     217.70.177.39  # dns0.gandi.net
     217.70.177.45  # dns1.gandi.net
     217.70.183.211 # dns2.gandi.net
     217.70.179.36  # dns3.gandi.net
     89.234.21.240
     68.232.182.102
     142.4.214.103
     68.232.182.102

     # deniedstresser.com
     2.99.137.170
     67.189.51.126
     69.141.220.196
     81.91.85.135
     86.132.197.23
     101.98.154.51
     142.4.214.103
     192.31.185.153
     192.210.200.244

     # isc.org queries
     69.64.32.45
     178.33.217.9
     208.184.79.22
     216.55.141.87
     )

for IP in ${IPS[@]}; do
    #iptables -D FORWARD -p udp -s $IP -j REJECT --reject-with icmp-host-prohibited
    iptables -D FORWARD -p udp -s $IP -j DROP
    #iptables -D FORWARD -p udp -d $IP -j DROP

    #iptables -A FORWARD -p udp -s $IP -j REJECT --reject-with icmp-host-prohibited
    #iptables -I FORWARD -p udp -s $IP -j DROP
    #iptables -A FORWARD -p udp -d $IP -j DROP
done

