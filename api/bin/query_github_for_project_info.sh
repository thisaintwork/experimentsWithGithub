#!/usr/bin/bash
set -o errexit

# ###########################################################
# Initialize the environment and global variables.
# -----------------------------------------------------------
BASEDIR=$(dirname "$0")

echo "# import the environment variables"
echo
. environment.sh

RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk
RELBINDIR=../bin

# ###########################################################
# LOCAL VARIABLE CUSTOMIZATION
# -----------------------------------------------------------

# override the RUNDIR here
#RUNDIR=.
RUNINPUTDIR=${RUNDIR}/input
RUNOUTPUTDIR=${RUNDIR}/output
RUNWRKDIR=${RUNDIR}/wrk
PYTHONEXE=/home/perftest/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/venv/bin/python
QRYFILENAME=input_query.graphql
OUTFILE=${OUTFILE}

cat<<EOF
# ###########################################################
# Announcement
# -----------------------------------------------------------
# Begin: $0
EOF

cp ${RELINPUTDIR}/${QRYFILENAME} ${RUNINPUTDIR}/${QRYFILENAME}
${PYTHONEXE} ${RELBINDIR}/queries_to_github.py --qry ${RUNINPUTDIR}/${QRYFILENAME}> ${RUNWRKDIR}/${OUTFILE}.xml


cat<<EOF
# End: $0
#---------------------------
EOF
