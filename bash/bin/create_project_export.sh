#!/usr/bin/bash

JAVAEXE=/snap/openjdk/current/jdk/bin/java

# run from the bash/bin directory
BASEDIR=$(dirname "$0")


RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk

DATENOW=$(date '+%Y%m%d-%H%M%S')
OUTFILE='github-results'
PYBINDIR=../../Python/bin
XFRMLIBDIR=../../transform/lib

cat<<EOF

This script will create a flat file from the github results.
rm ${BASEDIR}/${RELWRKDIR}/${OUTFILE}.xml


EOF

# Create the initial json output file
rm ${BASEDIR}/${RELWRKDIR}/${OUTFILE}.xml
/home/perftest/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/venv/bin/python ${BASEDIR}/${PYBINDIR}/queries_to_github.py --qry ${BASEDIR}/${PYBINDIR}/${RELINPUTDIR}/input_query.graphql > ${BASEDIR}/${RELWRKDIR}/${OUTFILE}-${DATENOW}.xml
cp ${BASEDIR}/${RELWRKDIR}/${OUTFILE}-${DATENOW}.xml ${BASEDIR}/${RELWRKDIR}/${OUTFILE}.xml
cp ${BASEDIR}/${RELWRKDIR}/${OUTFILE}-${DATENOW}.xml ${BASEDIR}/${XFRMLIBDIR}/${RELINPUTDIR}/${OUTFILE}-${DATENOW}.xml



# produce a flat file from the xml output.
# java -cp c:\saxon\saxon-he-11.1.jar net.sf.saxon.Query -t -qs:"current-date()"
${JAVAEXE} -cp ${BASEDIR}/${XFRMLIBDIR}/../saxon-he-11.5/saxon-he-11.5.jar net.sf.saxon.Transform -t -s:${BASEDIR}/${XFRMLIBDIR}/${RELINPUTDIR}/${OUTFILE}-${DATENOW}.xml -xsl:${BASEDIR}/${XFRMLIBDIR}/github-results-parse.xsl DATETIME="${DATENOW}" -o:${BASEDIR}/${XFRMLIBDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}.txt
cp ${BASEDIR}/${XFRMLIBDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}.txt ${BASEDIR}/${XFRMLIBDIR}/${RELOUTPUTDIR}/${OUTFILE}.txt
cp ${BASEDIR}/${XFRMLIBDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}.txt ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}.txt
cp ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}.txt ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}.txt


# Example input:
#Type|Status|IssueNumber|Title|LabelsCount|LabelString|AssignedSize|
#DRAFT_ISSUE|\u25b6 SPRINT READY||\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab\u25ab|0|||
#PULL_REQUEST|\ud83d\udeaeClear of the Backlog|9193|IQSS/9189-fix non-Globus properties|1|"Size: 3"|3|
#ISSUE|\ud83d\udeaeClear of the Backlog|208|Add Binder button for operating on datasets with Jupyter notebooks, Python, R, etc.|1|"Size: 3"|3|
#ISSUE|\ud83d\udeaeClear of the Backlog|9293|New filter-based design for the API authentication mechanisms|4|"Feature: API","User Role: API User","NIH OTA: 1.7.1 (reArchitecture)","Size: 33"|33|
#ISSUE|\ud83d\udeaeClear of the Backlog|9150|Create a javascript for the frontend that supports Fundref|3|"NIH OTA: 1.2.1","Size: 80","Deliverable: 5 Core PIDs"|80|
#PULL_REQUEST|\ud83d\udeaeClear of the Backlog|9086|Iqss/7349 2 improve related pub citation entry|2|"QDR","Size: 3"|3|
# run the resulting flat file through this command.
echo "Total size of all SPRINT READY issues and pull requests:"
cat ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}.txt  | grep 'SPRINT READY' | grep -v "^DRAFT" | cut -d'|' -f9 |  awk ' { sum += $1 } END { print sum }' > ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}-time.txt
cp ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}-time.txt ${BASEDIR}/${RELOUTPUTDIR}/time.txt
echo ""

# List of the issues in the flat file.
cat ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}.txt | grep 'SPRINT READY' | grep -v "^DRAFT" | cut -d'|' -f10,9 --output-delimiter='|' > ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}-issues_and_prs.txt
cp ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}-${DATENOW}-issues_and_prs.txt ${BASEDIR}/${RELOUTPUTDIR}/issues_and_prs.txt

echo "---"
head ${BASEDIR}/${RELOUTPUTDIR}/${OUTFILE}.txt
echo "---"
cat ${BASEDIR}/${RELOUTPUTDIR}/issues_and_prs.txt
echo "---"
cat ${BASEDIR}/${RELOUTPUTDIR}/time.txt
echo "---"






