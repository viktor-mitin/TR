#!/bin/sh

#############################################################################
#
# This script runs given AWS glue job and prints it's output to stdout.
# The first parameter is job name to run.
#
# Example: ./run_glue_job.sh Tests
#
#############################################################################

#set -x
set -e
set -E
set -u

JOB_NAME="$1"
SLEEP_TIME=3

#MAX_CONC_RUNS=$(aws glue get-job --job-name $JOB_NAME | jq '.Job.ExecutionProperty.MaxConcurrentRuns')
#echo "MAX RUNS: $MAX_CONC_RUNS"
#
##echo "Check if there are running jobs and wait until completed"
#while true; do
#    CURR_RUNS=$(aws glue get-job-runs --job-name $JOB_NAME | grep RUNNING | wc -l)
#    echo "CURR RUNS: $CURR_RUNS"
#    if [ $CURR_RUNS -lt $MAX_CONC_RUNS ]; then
#        break;
#    else
#        echo "The max number of concurent running job is reached, wait and retry"
#        sleep $SLEEP_TIME
#    fi
#done

#get job run id
JR=$(aws glue start-job-run --job-name $JOB_NAME  | jq '.JobRunId' | tr -d '"')
echo "Job Run Id: $JR"
sleep $SLEEP_TIME

#get job run status, wait job to complete
while true; do
    STATE=$(aws glue get-job-run --job-name $JOB_NAME --run-id $JR)
    echo -n $STATE | jq '.JobRun.JobRunState' #debug only
    echo $STATE | grep -q CompletedOn && break
    sleep $SLEEP_TIME
done

if echo $STATE | grep -q FAILED; then
    echo
    echo "ERROR - the job run has FAILED with the next errors:"
    echo
    #get job run output
    OUTPUT=$(aws logs get-log-events --log-group-name /aws-glue/python-jobs/error\
                  --log-stream-name $JR | jq '.events[0] | .message' | tr -d '"' )

    #pretty print output
    echo "$OUTPUT"
    echo
fi

#get job run output
echo
#echo "The job run output:"
OUTPUT=$(aws logs get-log-events --log-group-name /aws-glue/python-jobs/output\
              --log-stream-name $JR | jq '.events[0] | .message' | tr -d '"' )

echo "$OUTPUT"
echo

