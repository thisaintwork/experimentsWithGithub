#!/usr/bin/bash
set -o errexit


cat<<EOF

# ###########################################################
# Begin: $0
# -----------------------------------------------------------
EOF

# ###########################################################
# Initialize the environment variables.
# then read them in
# -----------------------------------------------------------
./environment-initialize.sh
. ./environment.sh


# ###########################################################
# Run the query against github
# This shell script will require the input variables.

# -----------------------------------------------------------
NEXTBINDIR=../../api/bin
#prep the local run environment
./clean_local_run_environment.sh ${NEXTBINDIR}
cp -v environment.sh ${NEXTBINDIR}/


cp -v  ${RELINPUTDIR}/project-fetch_snapshot-input.sh ${NEXTBINDIR}/${RELINPUTDIR}/
pushd  ${NEXTBINDIR}
./project-fetch_snapshot.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
cp -v ${RELINPUTDIR}/* ${RUNINPUTDIR}/
cp -v ${RELOUTPUTDIR}/* ${RUNWRKDIR}/
popd


# ###########################################################
# Transform the query results into a flat file
# -----------------------------------------------------------
NEXTBINDIR=../../transform/bin
#prep the local run environment
./clean_local_run_environment.sh ${NEXTBINDIR}
cp -v environment.sh ${NEXTBINDIR}

pushd  ${NEXTBINDIR}
cp -v  ${RUNWRKDIR}/${WRKINGFILE}.xml  ${RELINPUTDIR}/
./xform_xml_to_flat_file.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
cp -v ${RELINPUTDIR}/* ${RUNINPUTDIR}/
cp -v  ${RELOUTPUTDIR}/* ${RUNWRKDIR}/
popd

# ###########################################################
# copy all the most up to date run files to the latest run directory
# -----------------------------------------------------------
./latest_run-update.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1

cat<<EOF
# End: $0
#---------------------------
EOF






