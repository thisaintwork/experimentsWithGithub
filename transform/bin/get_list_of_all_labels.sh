#!/usr/bin/bash
set -o errexit

cat<<EOF
#===========================
# Begin: $0
EOF

echo "# Set basedir to current dir of this script"
JAVAEXE=/snap/openjdk/current/jdk/bin/java

BASEDIR=$(dirname "$0")
RELINPUTDIR=../input
RELOUTPUTDIR=../output
RELWRKDIR=../wrk
RELBINDIR=../bin

. environment.sh
# override the RUNDIR here
#RUNDIR=.
RUNINPUTDIR=${RUNDIR}/input
RUNOUTPUTDIR=${RUNDIR}/output
RUNWRKDIR=${RUNDIR}/wrk

XSLFILENAME=get_list_of_labels.xsl
RESULTFILE=labels_list


# java -cp c:\saxon\saxon-he-11.1.jar net.sf.saxon.Query -t -qs:"current-date()"
cp ${RELINPUTDIR}/${XSLFILENAME} ${RUNINPUTDIR}/${XSLFILENAME}
${JAVAEXE} -cp ${RELINPUTDIR}/../saxon-he-11.5/saxon-he-11.5.jar net.sf.saxon.Transform -t -s:${RUNWRKDIR}/${OUTFILE}.xml -xsl:${RUNINPUTDIR}/${XSLFILENAME}  RUNLABEL="${RUNLABEL}" -o:${RUNWRKDIR}/${RESULTFILE}.txt
cp ${RUNWRKDIR}/${RESULTFILE}.txt ${RUNWRKDIR}/${RESULTFILE}-00.txt
cat ${RUNWRKDIR}/${RESULTFILE}-00.txt | sort -u > ${RUNWRKDIR}/${RESULTFILE}.txt
echo "---"
head ${RUNWRKDIR}/${RESULTFILE}.txt
echo "---"
echo

cat<<EOF
# End: $0
#---------------------------
EOF
