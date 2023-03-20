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
# $(pwd)
# Begin: $0
EOF


# ###########################################################
# Declare input variables
# from the command line
# -----------------------------------------------------------
INPUTLIST=${1}
ACTION=${2}
PROJECT=${3}

ACTION=$(echo "$ACTION" |  sed "s/'//g")
PROJECT=$(echo "$PROJECT" | sed "s/'//g")


# e.g.
#'PULL_REQUEST'\t8940\t'dataverse'
COUNT=1
while read -r line;
do
       CMDNOW="ERROR"
       TYPE="ERROR"
       TYPEOF=$(echo "$line" | cut -f1 | sed "s/'//g")
       NUMB=$(echo "$line" | cut -f2 | sed "s/'//g")
       REPO=$(echo "$line" | cut -f3 | sed "s/'//g")

       [[ "${TYPEOF}" = "PULL_REQUEST" ]] && TYPE="pr"
       [[ "${TYPEOF}" = "ISSUE" ]] && TYPE="issue"
       CMDNOW="gh ${TYPE} edit ${NUMB} --repo ${REPO} --${ACTION} ${PROJECT}"
       echo "COUNTER: ${COUNT}"
       echo "    CMD: ${CMDNOW}"
      eval ${CMDNOW}
      EVAL_RETURN=$?
      # shellcheck disable=SC1033
      [ ${EVAL_RETURN} != "0" ] && EVAL_RETURN="ERROR"
      COUNT=$((COUNT+1))
      sleep 1

cat<<EOF

# ---------
# COUNT: ${COUNT} | RETURNED: ${EVAL_RETURN} | # $line | ${CMDNOW}
#
#

EOF


done < ${RELINPUTDIR}/${INPUTLIST}.txt

cat<<EOF
# End: $0
#---------------------------
EOF
