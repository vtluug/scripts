#!/bin/bash


# VTLUUG iptables things

echo 1 > /proc/sys/net/ipv4/conf/all/forwarding
# Nat
iptables --table nat --append POSTROUTING --source 10.98.0.0/16 --out-interface enp4s0 --jump SNAT --to 128.173.88.191
