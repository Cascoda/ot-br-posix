#!/bin/sh

# Delete all existing prefixes
existing_prefixes=$(ot-ctl prefix | grep /64 | sed 's/ .*//')

for prefix in $existing_prefixes; do
        ot-ctl prefix remove $prefix
done

# Get the randomly-generated ULA prefix from uci
ula_prefix=$(uci get network.globals.ula_prefix)

# Assuming the prefix is a /48, create the Thread ...:1::/64 prefix
thread_prefix=$(echo $ula_prefix | sed s!::/48!:1::/64!)

# Add the prefix using ot-ctl - the border routing code will see this
# when it runs and pick this prefix as the Off-Mesh Prefix

logger -t br-omr-enable Adding $thread_prefix for Off-Mesh Routing...

ot-ctl prefix add $thread_prefix paos high

logger -t br-omr-enable Prefix $thread_prefix added!

# Do not route link-local packets to the Thread network - they cannot
# be responded to by Thread devices
ip -6 route del fe80::/64 dev wpan0

# add route for NAT64
ot-ctl netdata publish route 64:ff9b::/96 s n med
# enable route
jool instance add --pool6 64:ff9b::/96
