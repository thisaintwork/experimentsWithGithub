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
JAVAEXE=/snap/openjdk/current/jdk/bin/java
XSLFILENAME=xml_to_flat_file

cat<<EOF

# ###########################################################
# Announcement
# -----------------------------------------------------------
# Begin: $0
EOF


# java -cp c:\saxon\saxon-he-11.1.jar net.sf.saxon.Query -t -qs:"current-date()"
# The input for this operation is in the latest run working directory
cp ../lib/${XSLFILENAME}.xsl  ${RELINPUTDIR}/
${JAVAEXE} -cp ../saxon-he-11.5/saxon-he-11.5.jar net.sf.saxon.Transform -t -s:${RELINPUTDIR}/${WRKINGFILE}.xml -xsl:${RELINPUTDIR}/${XSLFILENAME}.xsl  RUNLABEL="${RUNLABEL}" -o:${RELOUTPUTDIR}/${WRKINGFILE}.txt

echo "---"
head ${RELOUTPUTDIR}/${WRKINGFILE}.txt
echo "---"
echo

cat<<EOF
# End: $0
#---------------------------
EOF
