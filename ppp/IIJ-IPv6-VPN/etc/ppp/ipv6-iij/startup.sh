#!/bin/bash

# IPv6 over PPTP (IIJ) Startup Script
# @author Kenichi Maehashi

service radvd stop > /dev/null 2>&1

sysctl -q -w net.ipv6.conf.all.forwarding=0
sysctl -q -w net.ipv6.conf.all.accept_ra=1

pppd file $(dirname $0)/options

