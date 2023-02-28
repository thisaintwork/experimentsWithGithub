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


# java -cp c:\saxon\saxon-he-11.1.jar net.sf.saxon.Query -t -qs:"current-date()"
cp ${RELINPUTDIR}/${XSLFILENAME} ${RUNINPUTDIR}/${XSLFILENAME}


${JAVAEXE} -cp ${RELINPUTDIR}/../saxon-he-11.5/saxon-he-11.5.jar net.sf.saxon.Transform -t -s:${RUNWRKDIR}/${OUTFILE}.xml -xsl:${RUNINPUTDIR}/${XSLFILENAME}  RUNLABEL="${RUNLABEL}" -o:${RUNWRKDIR}/${OUTFILE}.txt
cp ${RUNWRKDIR}/${OUTFILE}.txt ${RUNWRKDIR}/${OUTFILE}-orig.txt
echo "---"
head ${RUNWRKDIR}/${OUTFILE}.txt
echo "---"
echo

cat<<EOF
# End: $0
#---------------------------
EOF
