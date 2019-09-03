#!/bin/sh

#############################################################################
#
# This script runs given glue job and prints it's output to stdout
# The first parameter is job name to run
#
# Example: ./run_glue_job.sh Tests
#
#############################################################################

set -x
set -e
set -u

JOB_NAME="$1"

#get job run id
jr=$(aws glue start-job-run --job-name $JOB_NAME  | jq '.JobRunId' | tr -d '"')

#get job run status, wait job to complete, TBD
while true; do
    STATE=$(aws glue get-job-run --job-name $JOB_NAME --run-id $jr)
    echo $STATE #debug only

    echo $STATE | grep -v FAILED || break
    sleep 3
done

#get job run output
OUTPUT=$(aws logs get-log-events --log-group-name /aws-glue/python-jobs/output\
              --log-stream-name $jr | jq '.events[0] | .message' | tr -d '"' )

#pretty print output
echo -e $OUTPUT

