#!/bin/bash

# IPv6 over PPTP (IIJ) Shutdown Script
# @author Kenichi Maehashi

ROUTE_DEVICE="br0"
IPV6_DEVICE="ipv6"
PIDFILE="/var/run/ppp-${IPV6_DEVICE}.pid"

PID=$(cat "${PIDFILE}" 2>/dev/null | head -n 1)
[ "${PID}" = "" ] && exit 1

kill -HUP ${PID}
tail -f --pid="${PID}" "${PIDFILE}" > /dev/null

service radvd stop > /dev/null

LOCAL_GLOBAL_SUBNET=$(ip -f inet6 -o addr show dev "${ROUTE_DEVICE}" scope global | awk '{print $4}')

route -A inet6 del "${LOCAL_GLOBAL_SUBNET}" dev "${ROUTE_DEVICE}"
ip addr del "${LOCAL_GLOBAL_SUBNET}" dev "${ROUTE_DEVICE}"

sysctl -q -w net.ipv6.conf.all.forwarding=0
sysctl -q -w net.ipv6.conf.all.accept_ra=1

