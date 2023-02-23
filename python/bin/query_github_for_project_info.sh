#!/usr/bin/bash
set -o errexit
cat<<EOF
#===========================
# Begin: $0
EOF

echo "# Set basedir to current dir of this script"
BASEDIR=$(dirname "$0")
PYTHONEXE=/home/perftest/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/venv/bin/python

. environment.sh
cp ${RELINPUTDIR}/input_query.graphql ${RUNINPUTDIR}/input_query.graphql
${PYTHONEXE} ${RELBINDIR}/queries_to_github.py --qry ${RUNINPUTDIR}/input_query.graphql > ${RUNWRKDIR}/${OUTFILE}.xml


cat<<EOF
# End: $0
#---------------------------
EOF
