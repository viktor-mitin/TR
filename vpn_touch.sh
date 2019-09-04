#!/bin/sh

if /opt/cisco/anyconnect/bin/vpn state | grep -q Connected ; then
    echo Connected to VPN, disconnecting...
    /opt/cisco/anyconnect/bin/vpn disconnect
    sudo sh -c "setleds -L -num < /dev/tty7"
else
    echo NOT Connected to VPN, connecting...
    ~/configs/vpn.exp
    sudo sh -c "setleds -L +num < /dev/tty7"
fi

