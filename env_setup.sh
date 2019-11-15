#!/bin/sh -x

#################################################################################
# This script configures TR aws environment and opens chrome with AWS console
# It uses vipaccess MFA tool, expect, cisco anyconnect, cloud-tool,
# selenium and chrome.
#
# Known Symantec VIP MFA issues and solutions:
# - The issue: vipaccess returns correct codes, however MFA does not work.
# Solution - go to https://vip.symantec.com/ and retest credentials ID.
# It will synchronize MFA state between symantec servers and your devices.
# After it MFA should work properly again.
#
# - The issue: after TR password change, cloud-tool may ask to enter
# the new password again. It asks it only once, and then it will not ask it again.
#
#################################################################################

### This function logins to AWS CLI with cloud-tool.
### The first parameter is profile name option - optional.
cloud_tool_login ()
{
    ~/.local/bin/cloud-tool -vvv $1 \
              vault-login -m `/home/c/.local/bin/vipaccess` \
              --account-id '074929092668' --role 'human-role/a205718-PowerUser2'
}

date

if /opt/cisco/anyconnect/bin/vpn state | grep -q Connected ; then
    echo Connected to VPN, ok
else
    echo NOT Connected to VPN, connecting...
    ~/w/TR/vpn.exp

    #The next command enables NumLock Led. This is cosmetic feature.
    #Known issue: setleds may not work properly (not stable) in case when it is
    #started from xserver (GUI).
    sudo sh -c "setleds -L +num < /dev/tty7"
fi

echo Vault login to cloud-tool


### default profile
cloud_tool_login

### tr-authorities-preprod profile
cloud_tool_login "--profile tr-authorities-preprod"


echo Get vault pass
~/w/TR/get_vault_pass.py


echo AWS login and Chrome restart
DISPLAY=:0.0 ~/w/TR/chrom_restart.sh

