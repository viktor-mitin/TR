#!/usr/bin/python3

import os
import sys
import time
import boto3

from pprint import pprint

job_name=sys.argv[1]
sleep_time=14

#job run id, example 'jr_99c5a6cf35370c1a2679b6e4393c5e5158866d025fdb6c55954f05a2061105d2'
jr='not set'

logs = boto3.client('logs')
glue = boto3.client('glue')

def print_log_group_output(log_group_name, log_stream_name):
    print()
    output = logs.get_log_events(logGroupName=log_group_name,
                     logStreamName=log_stream_name)['events'][0]['message']
    print(output)
    print("")


#get job run id
while True:
    try:
        jr=glue.start_job_run(JobName=job_name)['JobRunId']
        print("Job Run Id: ", jr)
        break
    except glue.exceptions.ConcurrentRunsExceededException:
        print("Job Run Id limit is reached, sleeping and retry again")
        time.sleep(sleep_time)


#get job run status, wait job to complete
state='not set'
while True:
    try:
        state=glue.get_job_run(JobName=job_name, RunId=jr)['JobRun']['CompletedOn']
        print("Job is completed", jr)
        break
    except KeyError:
        print("Job is not completed yet")
        time.sleep(sleep_time)


state=glue.get_job_run(JobName=job_name, RunId=jr)['JobRun']['JobRunState']
print(state)
if state == 'FAILED':
    print_log_group_output('/aws-glue/jobs/error', jr)

print_log_group_output('/aws-glue/jobs/output', jr)

