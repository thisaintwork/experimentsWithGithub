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


echo "# cp the list of repos and the labels to search for to the run input directory"
REPOS=repos_list_input
LABELSLIST=labels_list_input
cp  ${RELINPUTDIR}/${REPOS}.txt ${RUNWRKDIR}/${REPOS}.txt
cp  ${RELINPUTDIR}/${LABELSLIST}.txt ${RUNWRKDIR}/${LABELSLIST}.txt

COUNT=0
while read -r REPOLINE;
do
    echo "--- --- REPOLINE: ${REPOLINE}"

       #echo ${REPOLINE}
       CMDNOW="gh label list --repo '${REPOLINE}' --limit 300 --json name,color | jq -r '.[] | [.name, .color] | @tsv' | sed s'#\t#\|#g'"
       echo ${CMDNOW}
       eval ${CMDNOW}
       EVAL_RETURN=$?
       [ ${EVAL_RETURN} != "0" ] && EVAL_RETURN="ERROR"
       sleep 1
    COUNT=$((COUNT+1))
done < ${RUNWRKDIR}/${REPOS}.txt

cat<<EOF
# End: $0
#---------------------------
EOF
