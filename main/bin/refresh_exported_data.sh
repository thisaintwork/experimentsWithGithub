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
XSLFILENAME=xml_to_flat_file.xsl.xsl
OUTFILE=${OUTFILE}-flat

cat<<EOF
# ###########################################################
# Announcement
# -----------------------------------------------------------
# Begin: $0
EOF

# ###########################################################
# Run the query against github
# -----------------------------------------------------------
NEXTBINDIR=../../api/bin
cp environment.sh ${NEXTBINDIR}
pushd  ${NEXTBINDIR}
./query_github_for_project_info.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
popd

# ###########################################################
# Transform the query results into a flat file
# -----------------------------------------------------------
NEXTBINDIR=../../transform/bin
cp environment.sh ${NEXTBINDIR}
pushd  ${NEXTBINDIR}
./xform_xml_to_flat_file.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
popd









