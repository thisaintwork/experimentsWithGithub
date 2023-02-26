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

# IMPORTANT: RUNLABEL + RUNDIR controls the directory where the output is written.
RUNLABEL='20230226'
#RUNLABEL=$(date '+%Y%m%d-%H%M%S')
RUNDIR=../../run/${RUNLABEL}

# Hardcode the input here
cat<<EOF>environment.sh
RUNLABEL=${RUNLABEL}
RUNDIR=${RUNDIR}
OUTFILE='datafile'
EOF

# override the RUNDIR here
#RUNDIR=.

RUNINPUTDIR=${RUNDIR}/input
RUNOUTPUTDIR=${RUNDIR}/output
RUNWRKDIR=${RUNDIR}/wrk

# Setup the current rundir irectory
mkdir -p ${RUNDIR}
mkdir -p ${RUNINPUTDIR}
mkdir -p ${RUNOUTPUTDIR}
mkdir -p ${RUNWRKDIR}



RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk
RELBINDIR=../bin





echo "# import the environment variables"
echo
. environment.sh





########
NEXTBINDIR=../../api/bin
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
NEXTBINDIR=../../transform/bin
cp environment.sh ${NEXTBINDIR}
pushd  ${NEXTBINDIR}
./get_list_of_all_labels.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
popd

########
NEXTBINDIR=../../process_flat_file/bin
cp environment.sh ${NEXTBINDIR}
pushd  ${NEXTBINDIR}
./get_size.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
popd



########
#NEXTBINDIR=../../process_flat_file/bin
#cp environment.sh ${NEXTBINDIR}
#pushd  ${NEXTBINDIR}
#./process_flat_file.sh
#[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
#popd





