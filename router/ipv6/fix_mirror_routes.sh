#!/bin/sh
ip -6 route del 2001:468:c80:6103:20e:a6ff:fe8b:ea42 dev eth1 metric 0
ip -6 route add 2001:468:c80:6103:20e:a6ff:fe8b:ea42 dev eth1 metric 0
