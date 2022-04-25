#!/bin/bash -l

# Set SCC project
#$ -P my_superstar

# Specify hard time limit for the job. 
#   The job will be aborted if it runs longer than this time.
#   The default time, also selected here, is 12 hours.  You can increase this up to 720:00:00 for single processor jobs but your job will take longer to start.
#$ -l h_rt=12:00:00

module load python3/3.6.5
python -V