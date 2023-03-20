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
# -----------------------------------------------------------
NEXTBINDIR=../../api/bin
#prep the local run environment
../lib/clean_local_run_environment.sh ${NEXTBINDIR}
cp -v environment.sh ${NEXTBINDIR}/
cp -v ${RELINPUTDIR}/repo-fetch_issue_or_pr-by_label-input_repos.txt ${NEXTBINDIR}/${RELINPUTDIR}/
cp -v ${RELINPUTDIR}/repo-fetch_issue_or_pr-by_label-input_labels.txt ${NEXTBINDIR}/${RELINPUTDIR}/


pushd  ${NEXTBINDIR}
./repo-fetch_issue_or_pr-by_label.sh
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






