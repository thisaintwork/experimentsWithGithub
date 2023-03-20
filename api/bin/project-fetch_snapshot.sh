#!/usr/bin/bash
set -o errexit

# ###########################################################
# Initialize the environment and global variables.
# -----------------------------------------------------------
. ./environment.sh
. ${RELINPUTDIR}/project-fetch_snapshot-input.sh

# ###########################################################
# LOCAL VARIABLE CUSTOMIZATION
# -----------------------------------------------------------

# override the RUNDIR here
#RUNDIR=.
PYTHONEXE=/home/perftest/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/venv/bin/python


cat<<EOF

# ###########################################################
# Announcement
# -----------------------------------------------------------
# Begin: $0
$(cat ${RELINPUTDIR}/project-fetch_snapshot-input.sh)
EOF

# Query is run in the local directory and then copies of input and output are sent to run directory
cp ../lib/${QRYFILENAME} ${RELINPUTDIR}/
${PYTHONEXE} ./github-fetch_via_graphql.py --qry ${RELINPUTDIR}/${QRYFILENAME} > ${RELOUTPUTDIR}/${WRKINGFILE}.xml

cat<<EOF
# End: $0
#---------------------------
EOF
