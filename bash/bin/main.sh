#!/usr/bin/bash
set -o errexit

cat<<EOF

# This script will create a flat file from the github results.
# Eventually this script should be broken up and each of the steps should be put in it's own script in it's bin directory.
# run from the bash/bin directory"


EOF

echo "# Hardcode the environment variables"
echo "# Set basedir to current dir of this script"
BASEDIR=$(dirname "$0")

#DATENOW=$(date '+%Y%m%d-%H%M%S')

# IMPORTANT: DATENOW controls the directory where the output is written.
DATENOW='TESTING'
RUNDIR=../../run/${DATENOW}
RUNINPUTDIR=${RUNDIR}/input
RUNOUTPUTDIR=${RUNDIR}/output
RUNWRKDIR=${RUNDIR}/wrk

RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk
RELBINDIR=../bin



# Hardcode the input here
cat<<EOF>environment.sh
DATENOW=${DATENOW}
OUTFILE='github-results'
RUNDIR=${RUNDIR}
RUNINPUTDIR=${RUNDIR}/input
RUNOUTPUTDIR=${RUNDIR}/output
RUNWRKDIR=${RUNDIR}/wrk

RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk
RELBINDIR=../bin
EOF


echo "# import the environment variables"
echo
. environment.sh

# Setup the current rund irectory
mkdir -p ${RUNDIR}
mkdir -p ${RUNINPUTDIR}
mkdir -p ${RUNOUTPUTDIR}
mkdir -p ${RUNWRKDIR}




########
NEXTBINDIR=../../python/bin
cp environment.sh ${NEXTBINDIR}
pushd  ${NEXTBINDIR}
./query_github_for_project_info.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
popd

########
NEXTBINDIR=../../transform/bin
cp environment.sh ${NEXTBINDIR}
pushd  ${NEXTBINDIR}
./transform_xml_to_flatfile.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
popd


########
#NEXTBINDIR=../../bash/bin
#cp environment.sh ${NEXTBINDIR}
#pushd  ${NEXTBINDIR}
./process_flat_file.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
#popd

########
NEXTBINDIR=../../gh/bin
cp environment.sh ${NEXTBINDIR}
pushd  ${NEXTBINDIR}
./add_issue_to_project.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
popd




