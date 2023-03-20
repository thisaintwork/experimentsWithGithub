#!/usr/bin/bash
set -o errexit

# ###########################################################
# Initialize the environment variables.
# then read them in
# -----------------------------------------------------------
. ./environment.sh


cat<<EOF
# ###########################################################
# Begin: $0
# -----------------------------------------------------------
EOF

touch ${LATESTINPUTDIR}/empty.txt; rm ${LATESTINPUTDIR}/*
touch ${LATESTOUTPUTDIR}/empty.txt; rm ${LATESTOUTPUTDIR}/*
touch ${LATESTWRKDIR}/empty.txt; rm ${LATESTWRKDIR}/*

touch ${LATESTINPUTDIR}/empty-${RUNLABEL}.txt
touch ${LATESTOUTPUTDIR}/empty-${RUNLABEL}.txt
touch ${LATESTWRKDIR}/empty-${RUNLABEL}.txt


touch ${RUNINPUTDIR}/empty-${RUNLABEL}.txt
touch ${RUNOUTPUTDIR}/empty-${RUNLABEL}.txt
touch ${RUNWRKDIR}/empty-${RUNLABEL}.txt

cp -v ${RUNINPUTDIR}/* ${LATESTINPUTDIR}/
cp -v ${RUNOUTPUTDIR}/* ${LATESTOUTPUTDIR}/
cp -v ${RUNWRKDIR}/* ${LATESTWRKDIR}/

