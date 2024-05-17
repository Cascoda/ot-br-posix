#!/bin/sh

uci get network.lan6 > /dev/null && echo 'Device is already switch! Aborting...' && exit 1

uci add_list network.@device[0].ports='eth1'

uci set network.lan.proto=dhcp
uci delete network.lan.ipaddr
uci delete network.lan.netmask

uci delete network.wan.device
uci delete network.wan6.device

uci set network.lan6=interface

uci set network.lan6.proto=dhcpv6
uci set network.lan6.device=br-lan

service odhcpd disable
service dnsmasq disable

echo 'Applying changes... Hub will restart!'

uci commit
reboot
