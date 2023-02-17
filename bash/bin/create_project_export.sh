#!/usr/bin/bash

BASEDIR=$(dirname "$0")
RELBINDIR=.
RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk

DATENOW=$(date '+%Y%m%d-%H%M%S')
OUTFILE='github-results'
PYBINDIR=../../Python/bin
XFRMLIBDIR=../../transform/lib

cat<<EOF

rm ${RELWRKDIR}/${OUTFILE}.xml
/home/perftest/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/venv/bin/python ${PYBIN}/queries_to_github.py --qry ${PYBINDIR}/${RELINPUTDIR}/input_query.graphql > ${RELWRKDIR}/${OUTFILE}-${DATENOW}.xml
cp ${RELWRKDIR}/${OUTFILE}-${DATENOW}.xml ${RELWRKDIR}/${OUTFILE}.xml
cp ${RELWRKDIR}/${OUTFILE}.xml ${XFRMLIBDIR}/${RELWRKDIR}/${OUTFILE}.xml

EOF

# Create the initial json output file
rm ${RELWRKDIR}/${OUTFILE}.xml
/home/perftest/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/venv/bin/python ${PYBINDIR}/queries_to_github.py --qry ${PYBINDIR}/${RELINPUTDIR}/input_query.graphql > ${RELWRKDIR}/${OUTFILE}-${DATENOW}.xml
cp ${RELWRKDIR}/${OUTFILE}-${DATENOW}.xml ${RELWRKDIR}/${OUTFILE}.xml
cp ${RELWRKDIR}/${OUTFILE}.xml ${XFRMLIBDIR}/${RELWRKDIR}/${OUTFILE}.xml



