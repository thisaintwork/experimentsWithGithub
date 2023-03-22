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
INPUTLIST=${1}
GRAPHQL="$(cat ${RELINPUTDIR}/input_query-mutation.graphql | tr -s '\n' ' ')"


cat<<EOF

# ###########################################################
# Announcement
# -----------------------------------------------------------
# https://cli.github.com/manual/index
# $(pwd)
# Begin: $0
EOF


# ###########################################################
# Execution
#'PULL_REQUEST'\t8940\t'dataverse'
COUNT=1
while read -r line;
do
      CMDNOW="ERROR"
      PROJECTID="PROJ_ERR"
      ITEMID="ITEMID_ERR"

      PROJECTID=$(echo "$line" | cut -f1 | sed "s/'//g")
      ITEMID=$(echo "$line" | cut -f2 | sed "s/'//g")


      #CMDNOW="gh api graphql -F projectId='{${PROJECTID}}' -F itemID='{${ITEMID}}' -f query=${GRAPHQL}"
      CMDNOW="gh api graphql -F projectId='${PROJECTID}' -F itemID='${ITEMID}' -f query=${GRAPHQL}"
      echo "COUNTER: ${COUNT}"
      echo "    CMD: ${CMDNOW}"
      eval "${CMDNOW}"
      EVAL_RETURN=$?
      # shellcheck disable=SC1033
      [ ${EVAL_RETURN} != "0" ] && EVAL_RETURN="ERROR"
      COUNT=$((COUNT+1))
      sleep 1
exit 0
cat<<EOF

# ---------
# COUNT: ${COUNT} | RETURNED: ${EVAL_RETURN} | # $line | ${CMDNOW}
#
#

EOF


done < ${RELINPUTDIR}/${WRKINGFILE}.txt

cat<<EOF
# End: $0
#---------------------------
EOF
