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
cp environment.sh ${NEXTBINDIR}/
cp ${RELINPUTDIR}/repo-add_labels-input.txt ${NEXTBINDIR}/${RELINPUTDIR}/
pushd  ${NEXTBINDIR}
./repo-add_labels.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
popd


# ###########################################################
# copy all the most up to date run files to the latest run directory
# -----------------------------------------------------------
../lib/latest_run-update.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1








