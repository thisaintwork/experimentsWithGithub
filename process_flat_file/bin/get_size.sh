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
JAVAEXE=/snap/openjdk/current/jdk/bin/java
XSLFILENAME=xml_to_flat_file.xsl
OUTFILE=${OUTFILE}

cat<<EOF
# ###########################################################
# Announcement
# -----------------------------------------------------------
# Begin: $0
EOF

cp  ${RUNWRKDIR}/${OUTFILE}.txt ${RELINPUTDIR}/
cp  ${RUNWRKDIR}/${OUTFILE}.txt ${RELINPUTDIR}/${OUTFILE}-orig.txt

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

# remove draft issues
cat  ${RELINPUTDIR}/${OUTFILE}.txt  | grep -v "^DRAFT"  > ${RELWRKDIR}/${OUTFILE}.00.txt

# remove the header
tail -$(( $(wc -l < ${RELWRKDIR}/${OUTFILE}.00.txt;) -1 )) ${RELWRKDIR}/${OUTFILE}.00.txt > ${RELWRKDIR}/${OUTFILE}.10.txt

# pull out a unique list of  states e.g. 'udeaeClear of the Backlog'
cat  ${RELWRKDIR}/${OUTFILE}.10.txt | cut -d'|' -f1 | sort -u > ${RELWRKDIR}/${OUTFILE}.20.txt

# output the total size for the issues/PRs  in the flat file.
#State|Points|IssuesCount
echo "Column|Points|IssuesCount"

while read -r line;
do
   COUNT=$(cat  ${RELWRKDIR}/${OUTFILE}.10.txt | grep -c "$line")
   POINTS=$(cat  ${RELWRKDIR}/${OUTFILE}.10.txt | grep "$line" | cut -d'|' -f2 |  awk ' { sum += $1 } END { print sum }')
   echo "${line}|${POINTS}|${COUNT}"
done < ${RELWRKDIR}/${OUTFILE}.20.txt;



#cat  ${RELWRKDIR}/${OUTFILE}.01.txt > ${RELWRKDIR}/${OUTFILE}.02.txt;
#cat  ${RELWRKDIR}/${OUTFILE}.02.txt > ${RELWRKDIR}/${OUTFILE}.03.txt;
#cat  ${RELWRKDIR}/${OUTFILE}.03.txt > ${RELWRKDIR}/${OUTFILE}.04.txt;



cat<<EOF
# End: $0
#---------------------------
EOF
