#!/usr/bin/bash
set -o errexit
cat<<EOF
#===========================
# Begin: $0
EOF

PYTHONEXE=/home/perftest/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/venv/bin/python
BASEDIR=$(dirname "$0")

RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk
RELBINDIR=../bin

. environment.sh
# override the RUNDIR here
#RUNDIR=.
# set local variables based on the environment.sh settings
RUNINPUTDIR=${RUNDIR}/input
RUNOUTPUTDIR=${RUNDIR}/output
RUNWRKDIR=${RUNDIR}/wrk



cp ${RELINPUTDIR}/input_query.graphql ${RUNINPUTDIR}/input_query.graphql
${PYTHONEXE} ${RELBINDIR}/queries_to_github.py --qry ${RUNINPUTDIR}/input_query.graphql > ${RUNWRKDIR}/${OUTFILE}.xml


cat<<EOF
# End: $0
#---------------------------
EOF
