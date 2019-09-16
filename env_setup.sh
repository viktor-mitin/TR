#!/bin/sh

date

if /opt/cisco/anyconnect/bin/vpn state | grep -q Connected ; then
    echo Connected to VPN, ok
else
    echo NOT Connected to VPN, connecting...
    ~/w/TR/vpn.exp
    sudo sh -c "setleds -L +num < /dev/tty7"
fi


echo Vault login to cloud-tool
cloud-tool -vv vault-login  -m `/home/c/.local/bin/vipaccess` --account-id '074929092668' --role 'human-role/a205718-PowerUser2'

echo Get vault pass
~/w/TR/get_vault_pass.py


echo AWS login and Chrome restart
DISPLAY=:0.0 ~/w/TR/chrom_restart.sh

