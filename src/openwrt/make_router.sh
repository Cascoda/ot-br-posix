#!/bin/sh

uci get network.wan.device > /dev/null && echo "Device is already router! Aborting..." && exit 1

uci del_list network.@device[0].ports=eth1

uci set network.lan.proto=static
uci set network.lan.ipaddr=192.168.1.1
uci set network.lan.netmask=255.255.255.0

uci set network.wan.device=eth1
uci set network.wan6.device=eth1

uci delete network.lan6

echo 'Applying changes... Hub will restart!'

uci commit
reboot
