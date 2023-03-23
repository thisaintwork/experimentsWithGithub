#!/usr/bin/bash
set -o errexit

# ###########################################################
# Initialize the environment and global variables.
# -----------------------------------------------------------
. ./environment.sh

# ###########################################################
# LOCAL VARIABLE CUSTOMIZATION
# -----------------------------------------------------------

# override the RUNDIR here
#RUNDIR=.


cat<<EOF

# ###########################################################
# Announcement
# -----------------------------------------------------------
# https://cli.github.com/manual/index
# Begin: $0
EOF

# ###########################################################
# Declare input variables
# from the command line.
# -----------------------------------------------------------
LOGINORG=${1}
PROJECTNUM=${2}
QRYFILENAME=${3}


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
EOF

# Query is run in the local directory and then copies of input and output are sent to run directory
cp ../lib/${QRYFILENAME} ${RELINPUTDIR}/
${PYTHONEXE} ./github-fetch_via_graphql.py --qry ${RELINPUTDIR}/${QRYFILENAME} --org ${LOGINORG} --prjnum ${PROJECTNUM} > ${RELOUTPUTDIR}/${WRKINGFILE}.xml

cat<<EOF
# End: $0
#---------------------------
EOF
