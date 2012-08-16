IPv6 over PPTP VPN for Linux

# Requirements
System: RHEL 5
Packages: pptp, ppp, radvd
 ... pptp - http://poptop.sourceforge.net

# Start
chkconfig --add ipv6
chkconfig ipv6 on
service ipv6 start

