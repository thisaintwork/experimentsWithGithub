#!/usr/bin/bash
set -o errexit

cat<<EOF
#===========================
# Begin: $0
EOF

echo "# Set basedir to current dir of this script"
BASEDIR=$(dirname "$0")

echo "# import the environment variables for $0"
cat environment.sh
. environment.sh


echo "# output the total size for the issues/PRs  in the flat file."
cat  ${RUNWRKDIR}/${OUTFILE}.txt  | grep 'SPRINT READY' | grep -v "^DRAFT" | cut -d'|' -f8 |  awk ' { sum += $1 } END { print sum }' > ${RUNOUTPUTDIR}/size.txt

echo "# List of the issues & PRs in the flat file along with their repo."

tail -$(( $(wc -l < ${RUNWRKDIR}/${OUTFILE}.txt) -1 )) ${RUNWRKDIR}/${OUTFILE}.txt | grep 'SPRINT READY' | grep -v "^DRAFT" | cut -d'|' -f2,4,9 --output-delimiter='|' > ${RUNWRKDIR}/add_these.txt

# e.g.
#'PULL_REQUEST'|8940|'dataverse'
COUNT=0
while read -r line;
do
       TYPEOF=$(echo $line | cut -d'|' -f1)
       NUMB=$(echo $line | cut -d'|' -f2)
       REPO=$(echo $line | cut -d'|' -f3 | sed "s/'//g")

       CMDNOW="ERROR"
       TYPE="ERROR"
       [[ "${TYPEOF}" = "'PULL_REQUEST'" ]] && TYPE="pr"
       [[ "${TYPEOF}" = "'ISSUE'" ]] && TYPE="issue"
       CMDNOW="gh ${TYPE} edit ${NUMB} --repo 'IQSS/${REPO}' --add-project 'IQSS/dataverse'"
       #CMDNOW="gh ${TYPE} edit ${NUMB} --repo 'IQSS/${REPO}' --remove-project 'deleteMeAfterTesting'"
      eval ${CMDNOW}
      EVAL_RETURN=$?
      # shellcheck disable=SC1033
      [ ${EVAL_RETURN} != "0" ] && EVAL_RETURN="ERROR"
      COUNT=$((COUNT+1))

cat<<EOF

# ---------
# COUNT: ${COUNT} | RETURNED: ${EVAL_RETURN} | # $line | ${CMDNOW}
#
#

EOF


done < ${RUNWRKDIR}/add_these.txt

cat<<EOF
# End: $0
#---------------------------
EOF
