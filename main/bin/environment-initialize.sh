#!/usr/bin/bash
set -o errexit


# ###########################################################
# Initialize the environment
# -----------------------------------------------------------
# IMPORTANT: RUNLABEL + RUNDIR controls the directory where the output is written.
#RUNLABEL='20230226'
RUNLABEL=$(date '+%Y%m%d-%H%M%S')
RUNDIR=../../run/${RUNLABEL}

# override the RUNDIR here
#RUNDIR=.

RUNINPUTDIR=${RUNDIR}/input
RUNOUTPUTDIR=${RUNDIR}/output
RUNWRKDIR=${RUNDIR}/wrk
LATESTINPUTDIR=../../run/latest/input
LATESTOUTPUTDIR=../../run/latest/output
LATESTWRKDIR=../../run/latest/wrk

# Initialize the environment variables that will be used by all scripts
cat<<EOF>environment.sh
RUNLABEL=${RUNLABEL}

RUNDIR=${RUNDIR}
RUNINPUTDIR=${RUNDIR}/input
RUNOUTPUTDIR=${RUNDIR}/output
RUNWRKDIR=${RUNDIR}/wrk

WRKINGFILE='datafile'

RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk
RELBINDIR=../bin
RELLIBDIR=../lib

LATESTINPUTDIR=${LATESTINPUTDIR}
LATESTOUTPUTDIR=${LATESTOUTPUTDIR}
LATESTWRKDIR=${LATESTWRKDIR}


EOF

cat<<EOF
# ###########################################################
# Begin: $0
$(cat ./environment.sh)
# -----------------------------------------------------------
EOF


# Setup the current rundir irectory
mkdir -p -v ${RUNDIR}
mkdir -p -v ${RUNINPUTDIR}
mkdir -p -v ${RUNOUTPUTDIR}
mkdir -p -v ${RUNWRKDIR}
mkdir -p -v ${LATESTINPUTDIR}
mkdir -p -v ${LATESTOUTPUTDIR}
mkdir -p -v ${LATESTWRKDIR}

# environment.sh will exist in
# - the "main"  bin directory
# - the current run directory input directory
cp ./environment.sh ${RUNINPUTDIR}/














