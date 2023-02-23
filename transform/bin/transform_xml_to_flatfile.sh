#!/usr/bin/bash
set -o errexit

cat<<EOF
#===========================
# Begin: $0
EOF

echo "# Set basedir to current dir of this script"
JAVAEXE=/snap/openjdk/current/jdk/bin/java
BASEDIR=$(dirname "$0")
. environment.sh

echo "# produce a flat file from the xml output."
# java -cp c:\saxon\saxon-he-11.1.jar net.sf.saxon.Query -t -qs:"current-date()"
cp ${RELINPUTDIR}/github-results-parse.xsl ${RUNINPUTDIR}/github-results-parse.xsl
${JAVAEXE} -cp ${RELINPUTDIR}/../saxon-he-11.5/saxon-he-11.5.jar net.sf.saxon.Transform -t -s:${RUNWRKDIR}/${OUTFILE}.xml -xsl:${RUNINPUTDIR}/github-results-parse.xsl DATETIME="${DATENOW}" -o:${RUNWRKDIR}/${OUTFILE}.txt

echo "---"
head ${RUNWRKDIR}/${OUTFILE}.txt
echo "---"
echo

cat<<EOF
# End: $0
#---------------------------
EOF
