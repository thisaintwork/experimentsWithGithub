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


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# FIRST: Transform the query results into a flat file
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ###########################################################
# Declare input variables
NEXTBINDIR=../../api/bin
LOGINORG='IQSS'
PROJECTNUM='32'
QRYFILENAME='input_query.graphql'

# ###########################################################
# prep the local run environment
../lib/clean_local_run_environment.sh ${NEXTBINDIR}
cp -v environment.sh ${NEXTBINDIR}/

# ###########################################################
# Execution
pushd  ${NEXTBINDIR}
./project-fetch_snapshot.sh "${LOGINORG}" "${PROJECTNUM}" "${QRYFILENAME}"
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
cp -v ${RELINPUTDIR}/* ${RUNINPUTDIR}/
cp -v ${RELOUTPUTDIR}/* ${RUNWRKDIR}/
popd

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# SECOND: Transform the query results into a flat file
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ###########################################################
# Declare input variables
NEXTBINDIR=../../transform/bin

# ###########################################################
# prep the local run environment
../lib/clean_local_run_environment.sh ${NEXTBINDIR}
cp -v environment.sh ${NEXTBINDIR}

# ###########################################################
# Execution
pushd  ${NEXTBINDIR}
cp -v  ${RUNWRKDIR}/${WRKINGFILE}.xml ${RELINPUTDIR}/
./xform_xml_to_flat_file.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
cp -v ${RELINPUTDIR}/* ${RUNINPUTDIR}/
cp -v  ${RELOUTPUTDIR}/* ${RUNWRKDIR}/
cp -v  ${RELOUTPUTDIR}/* ${RUNOUTPUTDIR}/
popd

# ###########################################################
# copy all the most up to date run files to the latest run directory
# -----------------------------------------------------------
../lib/latest_run-update.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1

cat<<EOF
# End: $0
#---------------------------
EOF






