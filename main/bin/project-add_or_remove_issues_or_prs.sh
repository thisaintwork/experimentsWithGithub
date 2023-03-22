#!/usr/bin/bash
set -o errexit


cat<<EOF

# ###########################################################
# $(pwd)
# Begin: $0
# -----------------------------------------------------------
EOF

# ###########################################################
# Initialize the environment variables.
# then read them in
# -----------------------------------------------------------
./environment-initialize.sh
. ./environment.sh

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Transform the query results into a flat file
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




# ###########################################################
# Declare input variables
NEXTBINDIR=../../api/bin
INPUTFILE='project_snapshot-FundedDeliverables-timestamp'




# ###########################################################
# prep the local input file
#      input:
#     output: ProjectID, IssueID
#   postcond: the output file is put into the local directory where the next script will expect it.
# input file looks like the following  except it's tab delimited. # Note that it includes project title, project ID, Issue or PR number, and Issue or PR ID
# ProjectTitle|ProjectNumber|ProjectID|Status|AssignedSize|Type|IssueNumber|IssueID|Title|Repository|Comments|LabelString|closingIssuesReferences|OG Queue|Closed|ClosedAt|RUNLABEL|LabelsCount|NIH OTA: 1.5.1|Size: 10|pm.f01-d-y01-a05-t01|pm.f01-d-y01-a05-t02|Type: Suggestion|Feature: Metadata|User Role: Curator|User Role: Depositor|bklog: NeedsDiscussion|D: 5 Core PIDs|Size: NoSprintCost|sz.Medium|Status: UX & UI|Feature: Harvesting|NIH OTA: 1.1.1|pm.f01-d-y01-a01-t01|hdc|1|3a|3b|NIH OTA: 1.2.2|pm.f01-d-y01-a02-t02|NIH OTA: 1.2.1|pm.f01-d-y01-a02-t01|Size: 80|Size: 3|NIH OTA DC|spike|Feature: Controlled Vocabulary|pm.f02|NIH: NetCDF|NIH OTA: 1.6.2|pm.f01-d-y01-a06-t02|pm.f01-d-y01-a04-t01|pm.f01-d-y01-a04-t02|pm.epic.nih_harvesting|NIH OTA: 1.4.1|Size: 33|Size: Queued|pm.epic.nih_harvesting_framework|Type: Bug|User Role: Superuser|Testing: API|User Role: Sysadmin|Feature: API Guide|Feature: Code Infrastructure|Feature: File Upload & Handling|pm.f01|D: Dev|ops: Email Issue|NIH OTA: 1.6.1|D: OpenDP Integration|pm.f01-d-y01-a06-t01|Working Group: SWC|HERMES|NIH OTA: 1.3.1|pm.f01-d-y01-a03-t01|pm.f01-d-y01-a03-t02|Feature: Account & User Info|NIH OTA: 1.7.1 (reArchitecture)|pm.f01-d-y01-a07-t01|pm.f01-d-y01-a07-t02|DevOps: Problem|pm.f01-d-y02-a05-t01|pm.f01-d-y02-a03-t02|pm.f01-d-y02-a03-t01
# 'FundedDeliverables'|32|'PVT_kwDOAApNpc4AG11J'|'NIH OTA: 1.5.1 & 1.5.2'|10|'ISSUE'|75|PVTI_lADOAApNpc4AG11JzgC0cQE|'Spike: finalize the plan for transition to Make Data Count, how to display the metrics, how to handle legacy counts'|'dataverse.harvard.edu'||'NIH OTA: 1.5.1','Size: 10','pm.f01-d-y01-a05-t01','pm.f01-d-y01-a05-t02'||'NIH OTA: 1.5.1 & 1.5.2'|False|'None'|'TEST'|4|1|1|1|1
cat ${RELINPUTDIR}/${INPUTFILE}.txt | cut -f 3,8   > ${RELWRKDIR}/${WRKINGFILE}.0.txt
LINES="$(wc -l ${RELWRKDIR}/${WRKINGFILE}.0.txt | cut -f1 -d' ')"
tail -$(expr "$LINES" - 1 ) "${RELWRKDIR}/${WRKINGFILE}.0.txt" > ${RELWRKDIR}/${WRKINGFILE}.txt


# ###########################################################
# prep the local run environment
../lib/clean_local_run_environment.sh ${NEXTBINDIR}
cp -v environment.sh ${NEXTBINDIR}/
cp -v ${RELWRKDIR}/${WRKINGFILE}.txt ${NEXTBINDIR}/${RELINPUTDIR}/
cp -v ${NEXTBINDIR}/${RELLIBDIR}/*.graphql ${NEXTBINDIR}/${RELINPUTDIR}/

# ###########################################################
# Execution
pushd  ${NEXTBINDIR}
./project-add_or_remove_issues_or_prs.sh "${WRKINGFILE}.txt"
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1
cp -v ${RELINPUTDIR}/* ${RUNINPUTDIR}/
cp -v ${RELOUTPUTDIR}/* ${RUNWRKDIR}/
popd

# ###########################################################
# copy all the most up to date run files to the latest run directory
# -----------------------------------------------------------
../lib/latest_run-update.sh
[[ "$?" != "0" ]] && echo "ERROR: $?" && exit 1

cat<<EOF
# End: $0
#---------------------------
EOF






