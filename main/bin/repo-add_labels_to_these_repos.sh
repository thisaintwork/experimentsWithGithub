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
./clean_local_run_environment.sh ${NEXTBINDIR}
cp -v environment.sh ${NEXTBINDIR}/

cp -v ${RELINPUTDIR}/repo-add_labels_to_these_repos-input_labels.txt ${NEXTBINDIR}/${RELINPUTDIR}/
cp -v ${RELINPUTDIR}/repo-add_labels_to_these_repos-input_repos.txt ${NEXTBINDIR}/${RELINPUTDIR}/

pushd  ${NEXTBINDIR}
./repo-add_labels.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
cp -v ${RELINPUTDIR}/* ${RUNINPUTDIR}/
cp -v ${RELOUTPUTDIR}/* ${RUNWRKDIR}/
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






