#!/usr/bin/bash
set -o errexit


cat<<EOF

# ###########################################################
# $(pwd)
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
# Transform the query results into a flat file
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ###########################################################
# Declare input variables
NEXTBINDIR=../../api/bin
INPUTFILE='project-add_or_remove_issues_or_prs-input'
#ACTION='add-project'
ACTION='remove-project'
PROJECT="'FundedDeliverables'"

# ###########################################################
# prep the local run environment
../lib/clean_local_run_environment.sh ${NEXTBINDIR}
cp -v environment.sh ${NEXTBINDIR}/
cp -v ${RELINPUTDIR}/${INPUTFILE}.txt ${NEXTBINDIR}/${RELINPUTDIR}/
# ###########################################################
# Execution
pushd  ${NEXTBINDIR}
./project-add_or_remove_issues_or_prs.sh "${INPUTFILE}" "${ACTION}" "${PROJECT}"
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
cp -v ${RELINPUTDIR}/* ${RUNINPUTDIR}/
cp -v ${RELOUTPUTDIR}/* ${RUNWRKDIR}/
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






