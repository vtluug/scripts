#!/bin/bash

# VTLUUG iptables things

# Nat
iptables --table nat --append POSTROUTING --source 10.98.0.0/16 --out-interface enp2s0 --jump SNAT --to 128.173.88.191
