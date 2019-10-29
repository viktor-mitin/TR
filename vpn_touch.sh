#!/bin/sh

date > ~/w/tr_vpn.log

if /opt/cisco/anyconnect/bin/vpn state | grep -q Connected ; then
    echo Connected to VPN, disconnecting...
    /opt/cisco/anyconnect/bin/vpn disconnect
    sudo sh -c "setleds -L -num < /dev/tty7"
else
    echo NOT Connected to VPN, connecting...

    # There is a strange bug, that sometimes VPN connection
    # cannot be established without vpnagentd service restart
    sudo service vpnagentd restart
    sleep 2

    ~/w/TR/vpn.exp
    sudo sh -c "setleds -L +num < /dev/tty7"
fi

