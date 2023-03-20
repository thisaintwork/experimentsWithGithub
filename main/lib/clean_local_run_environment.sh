#!/bin/bash
cat<<EOF

# ###########################################################
# Begin: $0
# -----------------------------------------------------------
EOF

. ./environment.sh
    pushd $1
    touch ${RELINPUTDIR}/empty.txt; rm ${RELINPUTDIR}/*; touch ${RELINPUTDIR}/empty.txt;
    touch ${RELOUTPUTDIR}/empty.txt; rm ${RELOUTPUTDIR}/*; touch ${RELOUTPUTDIR}/empty.txt
    touch ${RELWRKDIR}/empty.txt; rm ${RELWRKDIR}/*; touch ${RELWRKDIR}/empty.txt
    popd


cat<<EOF
# End: $0
#---------------------------
EOF