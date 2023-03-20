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
REPOS='repo-fetch_labels-input_repos'

COUNT=0
while read -r REPOLINE;
do
    echo "--- --- REPOLINE: ${REPOLINE}"

       #echo ${REPOLINE}
       CMDNOW="gh label list --repo ${REPOLINE} --limit 300 --json name,color,description | jq -r '.[] | [.name, .color, .description] | @tsv' | sed s'#\t#\"\t\"#g' | sed s'#^#\"#g' | sed s'/$/\"/g'"
       echo ${CMDNOW}
       OUTFILE=$( echo "${WRKINGFILE}-${REPOLINE}" | sed "s/'//g" | sed "s/\./_/g" | sed "s#\/#-#g" )
       eval ${CMDNOW} > ${RELOUTPUTDIR}/${OUTFILE}-output.txt
       EVAL_RETURN=$?
       [ ${EVAL_RETURN} != "0" ] && EVAL_RETURN="ERROR"
       sleep 1
    COUNT=$((COUNT+1))
done < ${RELINPUTDIR}/${REPOS}.txt

cat<<EOF
# End: $0
#---------------------------
EOF
