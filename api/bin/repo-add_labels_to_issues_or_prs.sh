#!/usr/bin/bash
set -o errexit

# ###########################################################
# Initialize the environment and global variables.
# -----------------------------------------------------------
. ./environment.sh

# ###########################################################
# LOCAL VARIABLE CUSTOMIZATION
# -----------------------------------------------------------

# override the RUNDIR here
#RUNDIR=.


cat<<EOF

# ###########################################################
# Announcement
# -----------------------------------------------------------
# https://cli.github.com/manual/index
# Begin: $0
EOF

# ###########################################################
# Declare input variables
# from the command line
# -----------------------------------------------------------
INPUTLIST=${1}

COUNT=1
while read -r INPUTLINE || [ -n "INPUTLINE" ]
do
  echo "--- INPUTLINE: ${INPUTLINE}"

  REPO=$(echo "${INPUTLINE}" | cut -f1)
  ID=$(echo "${INPUTLINE}" | cut -f2)
  TYPE=$(echo "${INPUTLINE}" | cut -f3)
  LBLNAME=$(echo "${INPUTLINE}" | cut -f5)

  echo "--- --- ---"
  CMDNOW="gh ${TYPE} edit ${ID} --add-label ${LBLNAME} --repo ${REPO}"
  echo "${COUNT}: ${CMDNOW} -> ${OUTFILE}"
  eval ${CMDNOW}
  EVAL_RETURN=$?
  [ ${EVAL_RETURN} != "0" ] && EVAL_RETURN="ERROR"
  sleep 1

  COUNT=$((COUNT+1))
done < ${RELINPUTDIR}/${INPUTLIST}.txt

cat<<EOF
# End: $0
#---------------------------
EOF
