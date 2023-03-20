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

touch ${LATESTINPUTDIR}/empty.txt
touch ${LATESTOUTPUTDIR}/empty.txt
touch ${LATESTWRKDIR}/empty.txt


touch ${RUNINPUTDIR}/empty.txt
touch ${RUNOUTPUTDIR}/empty.txt
touch ${RUNWRKDIR}/empty.txt

rm ${LATESTINPUTDIR}/*
rm ${LATESTOUTPUTDIR}/*
rm ${LATESTWRKDIR}/*

cp -v ${RUNINPUTDIR}/* ${LATESTINPUTDIR}/
cp -v ${RUNOUTPUTDIR}/* ${LATESTOUTPUTDIR}/
cp -v ${RUNWRKDIR}/* ${LATESTWRKDIR}/

