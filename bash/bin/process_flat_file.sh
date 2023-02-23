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


# Example input:
#Type|Status|IssueNumber|Title|LabelsCount|LabelString|AssignedSize|
#DRAFT_ISSUE|\u25b6 SPRINT READY||\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab|0|||
#PULL_REQUEST|\ud83d\udeaeClear of the Backlog|9193|IQSS/9189-fix non-Globus properties|1|"Size: 3"|3|
#ISSUE|\ud83d\udeaeClear of the Backlog|208|Add Binder button for operating on datasets with Jupyter notebooks, Python, R, etc.|1|"Size: 3"|3|
#ISSUE|\ud83d\udeaeClear of the Backlog|9293|New filter-based design for the API authentication mechanisms|4|"Feature: API","User Role: API User","NIH OTA: 1.7.1 (reArchitecture)","Size: 33"|33|
#ISSUE|\ud83d\udeaeClear of the Backlog|9150|Create a javascript for the frontend that supports Fundref|3|"NIH OTA: 1.2.1","Size: 80","Deliverable: 5 Core PIDs"|80|
#PULL_REQUEST|\ud83d\udeaeClear of the Backlog|9086|Iqss/7349 2 improve related pub citation entry|2|"QDR","Size: 3"|3|
# run the resulting flat file through this command.
echo "# output the total size for the issues/PRs  in the flat file."
cat  ${RUNWRKDIR}/${OUTFILE}.txt  | grep 'SPRINT READY' | grep -v "^DRAFT" | cut -d'|' -f8 |  awk ' { sum += $1 } END { print sum }' > ${RUNOUTPUTDIR}/size.txt

echo "# List of the issues & PRs in the flat file along with their repo."
head -1 ${RUNWRKDIR}/${OUTFILE}.txt  | cut -d'|' -f2,4,9 --output-delimiter='|' > ${RUNWRKDIR}/issues_and_prs.txt
cat     ${RUNWRKDIR}/${OUTFILE}.txt | grep 'SPRINT READY' | grep -v "^DRAFT" | cut -d'|' -f2,4,9 --output-delimiter='|' >> ${RUNWRKDIR}/issues_and_prs.txt


cat<<EOF
# End: $0
#---------------------------
EOF
