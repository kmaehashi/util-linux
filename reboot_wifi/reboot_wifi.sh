#!/bin/sh -e

# Reboot CG-WLR300NM from console

MGMT_HOST="192.168.0.2"
MGMT_USER="root"
MGMT_PASS="pass"

(
echo "authen_username=${MGMT_USER}&authen_password=${MGMT_PASS}" | curl -d@- -s "http://${MGMT_HOST}/goform/asp_login"
curl -s "http://${MGMT_HOST}/goform/asp_reboot"
) > /dev/null
