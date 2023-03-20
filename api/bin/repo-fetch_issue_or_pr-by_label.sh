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
REPOS=repo-fetch_issue_or_pr-by_label-input_repos
LABELSLIST=repo-fetch_issue_or_pr-by_label-input_labels

COUNT=1
while read -r LABELLINE || [ -n "$LABELLINE" ]
do
  LBLNAME=$(echo "${LABELLINE}" | cut -f1)
  LBLDESC=$(echo "${LABELLINE}" | cut -f2)
  LBLCLR=$(echo "${LABELLINE}" | cut -f3)
  echo "--- LABELLINE:  ${LBLNAME} | ${LBLDESC} | ${LBLCLR}"

  while read -r REPOLINE || [ -n "$REPOLINE" ]
  do
    echo "--- --- REPOLINE: ${REPOLINE}"

       for TYPEOF in 'issues' 'prs';
       do
          echo "--- --- ---"
          #echo "${REPOLINE}|${LABELLINE}|${TYPEOF}|${COUNT}"
          # gh search issues --label 'Dataset: large number of files' --repo 'IQSS/dataverse'
          CMDNOW="gh search ${TYPEOF} --label ${LBLNAME} --repo ${REPOLINE}"
          OUTFILE=$( echo "${WRKINGFILE}+${REPOLINE}+${LBLNAME}+${TYPEOF}" | sed "s/'//g" | sed "s/\./_/g" | sed "s#\/#-#g" | sed "s# #_#g")
          echo "${COUNT}: ${CMDNOW} -> ${OUTFILE}"
          eval ${CMDNOW} >> ${RELOUTPUTDIR}/${OUTFILE}.txt
          EVAL_RETURN=$?
          [ ${EVAL_RETURN} != "0" ] && EVAL_RETURN="ERROR"
          sleep 1
       done
       COUNT=$((COUNT+1))

       if [ $((COUNT % 5)) -eq 0 ]; then
         sleep 10
       fi

  done < ${RELINPUTDIR}/${REPOS}.txt
done < ${RELINPUTDIR}/${LABELSLIST}.txt

cat<<EOF
# End: $0
#---------------------------
EOF
