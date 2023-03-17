#!/usr/bin/bash
set -o errexit

# ###########################################################
# Initialize the environment and global variables.
# -----------------------------------------------------------
BASEDIR=$(dirname "$0")

echo "# import the environment variables"
echo
. environment.sh

RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk
RELBINDIR=../bin

# ###########################################################
# LOCAL VARIABLE CUSTOMIZATION
# -----------------------------------------------------------

# override the RUNDIR here
#RUNDIR=.
RUNINPUTDIR=${RUNDIR}/input
RUNOUTPUTDIR=${RUNDIR}/output
RUNWRKDIR=${RUNDIR}/wrk
OUTFILE=${OUTFILE}

cat<<EOF
# ###########################################################
# Announcement
# -----------------------------------------------------------
# https://cli.github.com/manual/index
# Begin: $0
EOF


echo "# cp the list of repos and the labels to search for to the run input directory"
REPOS=repos_tobe_added_to
LABELSLIST=labels_tobe_added
cp  ${RELINPUTDIR}/${REPOS}.txt ${RUNWRKDIR}/${REPOS}.txt
cp  ${RELINPUTDIR}/${LABELSLIST}.txt ${RUNWRKDIR}/${LABELSLIST}.txt

COUNT=0
while read -r LABELLINE;
do
  echo "--- LABELLINE: ${LABELLINE}"
  while read -r REPOLINE;
  do
    echo "--- --- REPOLINE: ${REPOLINE}"

       #echo ${REPOLINE}
       for TYPEOF in 'issues' 'prs';
       do
          echo "--- --- ---"
          echo "${REPOLINE}|${LABELLINE}|${TYPEOF}|${COUNT}"
          # gh search issues --label 'Dataset: large number of files' --repo 'IQSS/dataverse'
          CMDNOW="gh search ${TYPEOF} --label '${LABELLINE}' --repo '${REPOLINE}'"
          echo ${CMDNOW}
          eval ${CMDNOW}
          EVAL_RETURN=$?
          [ ${EVAL_RETURN} != "0" ] && EVAL_RETURN="ERROR"
          sleep 1
       done
  done < ${RUNWRKDIR}/${REPOS}.txt
  COUNT=$((COUNT+1))
done < ${RUNWRKDIR}/${LABELSLIST}.txt

cat<<EOF
# End: $0
#---------------------------
EOF
