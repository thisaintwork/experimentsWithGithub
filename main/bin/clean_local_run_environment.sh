#!/bin/bash
cat<<EOF

# ###########################################################
# Begin: $0
# -----------------------------------------------------------
EOF

. ./environment.sh
    pushd $1
    touch ${RELINPUTDIR}/empty.txt; rm ${RELINPUTDIR}/*
    touch ${RELOUTPUTDIR}/empty.txt; rm ${RELOUTPUTDIR}/*
    touch ${RELWRKDIR}/empty.txt; rm ${RELWRKDIR}/*
    popd


cat<<EOF
# End: $0
#---------------------------
EOF