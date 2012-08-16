#!/bin/bash

# IPv6 over PPTP (IIJ) ipv6-up hook
# @author Kenichi Maehashi

ROUTE_DEVICE="br0"
IPV6_DEVICE="ipv6"

# interface-name tty-device speed local-link-local-address remote-link-local-address ipparam
IFNAME="${1}"
TTY="${2}"
SPEED="${3}"
LOCAL_LINK_ADDR="${4}"
REMOTE_LINK_ADDR="${5}"
IPPARAM="${6}"

[ "${IFNAME}" != "${IPV6_DEVICE}" ] && exit 0

while [ "${LOCAL_GLOBAL_SUBNET}" = "" ]; do
    LOCAL_GLOBAL_SUBNET=$(ip -f inet6 -o addr show dev "${IFNAME}" scope global | awk '{print $4}')
done

sysctl -q -w net.ipv6.conf.all.forwarding=1
sysctl -q -w net.ipv6.conf.all.accept_ra=0

cat << _EOF_ > /etc/radvd.conf
interface ${ROUTE_DEVICE}
{
    AdvSendAdvert on;
    MinRtrAdvInterval 30;
    MaxRtrAdvInterval 100;
    prefix ${LOCAL_GLOBAL_SUBNET}
    {
        AdvOnLink on;
        AdvAutonomous on;
        AdvRouterAddr on;
    };
};
_EOF_

service radvd start > /dev/null

ip addr add "${LOCAL_GLOBAL_SUBNET}" dev "${ROUTE_DEVICE}"

route -A inet6 add default dev "${IFNAME}"
route -A inet6 add "${LOCAL_GLOBAL_SUBNET}" dev "${ROUTE_DEVICE}"

# Update DNS
#cat << _EOF_ | nsupdate -k /var/named/chroot/var/named/keys/update.key
#zone example.net
#prereq yxrrset ipv6.example.net. IN AAAA
#update delete ipv6.example.net.
#update add ipv6.example.net. 300 IN AAAA ${LOCAL_GLOBAL_SUBNET%/*}
#send
#_EOF_

# Update Dynamic DNS
#cat << _EOF_ | curl --config -
#url = "https://www.sitelutions.com/dnsup?user=<<USER>>&pass=<<PASSWORD>>&id=<<ID>>&ip=${LOCAL_GLOBAL_SUBNET%/*}"
#_EOF_
