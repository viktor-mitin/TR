#!/bin/sh

#############################################################################
#
# This script deletes given AWS iam role and it's policies
# The first parameter is role name to delete.
#
# Example: ./iam_delete_role_and_policies.sh role_name_to_delete
#
#############################################################################

#set -x
set -e
set -E
set -u

ROLE_NAME="$1"

#Get list of role policies
#TBD
aws iam list-role-policies --role-name $ROLE_NAME

#delete each policy from the role
aws iam delete-role-policy --role-name $ROLE_NAME --policy-name $POLICY_NAME

#delete the role
aws iam delete-role --role-name $ROLE_NAME

