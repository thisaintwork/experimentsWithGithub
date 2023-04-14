# e.g. Run;
# python mutation-update_labels.py --qry ../lib/mutation-update_label.graphql --in_file ../../main/input/list-labels_combined.txt

from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport
import os
import json
import argparse
from json2xml import json2xml
from dict2xml import dict2xml
#from json2xml.utils import readfromurl, readfromstring, readfromjso
#from pypi import json2xml

from datetime import datetime
import time

# =================================================================
# grab the input file
# =================================================================
#         input: from a file
#                The first line is a header line
#                The lines that follow are the data in columns separated by tabs
#        output: result - this is an xml encoded json result string. The result string doesn't count for much here.
#       precond: for the file
#                has a column with the label: 'LabelID'
#                has a column with the lable: 'LabelName2'
#                Later code depends on these two columns being present
#                example input:
#
#      postcond: The data is read in
# e.g output
class DataReader:
    def __init__(self, filename):
        with open(filename, 'r') as file:
            self.data = file.read()

    def to_dict(self):
        # Split the data into lines
        lines = self.data.strip().split('\n')

        # Get the keys from the first line
        keys = lines[0].split('\t')

        #print out the keys
        for key in keys:
            print(f"key: {key}")

        # Initialize an empty list to store dictionaries
        result = []

        # Iterate through each line except the first one
        for line in lines[1:]:

            # print the raw line
            print(f"line: {line}")

            # Split the line by tab characters
            fields = line.split('\t')

            # print the raw line
            print(f"line: {len(fields)}")
            print(f"line: {len(keys)}")

            # Create a dictionary for each issue
            issue_dict = {keys[i]: fields[i] for i in range(len(keys))}
            #for i in range(len(keys))}
            #  issue_dict = {keys[i]: fields[i]

            # Append the dictionary to the result list
            result.append(issue_dict)

        return result




def load_query(query_file):
    with open(query_file) as file:
        return gql(file.read())


# =================================================================
# get a list of all labels in a repository
# =================================================================
#         input: itemId: The id of the label to be modified.
#              : name: The name of the label. In this case we are only modifying the name.
#        output: result - this is an xml encoded json result string. The result string doesn't count for much here.
#       precond: requires a special Accept header
#                   e.g. headers = {"Authorization": "Bearer " + auth_token_val, "Accept": "application/vnd.github.bane-preview+json"}
#                   see:https://docs.github.com/en/graphql/overview/schema-previews#labels-preview
#      postcond: result is printed to stdout
#
# e.g output
#<?xml version="1.0" encoding="UTF-8"?>
#<root>
#<pages>
#  <updateLabel>
#    <label>
#      <id>LA_kwDOANZmvM8AAAABOyytzA</id>
#      <name>pm.GREI-d-1.1.1</name>
#    </label>
#  </updateLabel>
#</pages>
#</root>
#
# e.g input - In this case all the columms are extra excecpt fpr 2
#IDX	Organization	OrganizationID	Repo	RepoID	LabelName	LabelID	LabelColor	LabelDescription	RUNLABEL	LabelName2
#286	'IQSS'	'MDEyOk9yZ2FuaXphdGlvbjY3NTIzNw=='	'dataverse-frontend'	'R_kgDOI3pPiw'	'pm.f01-d-y01-a01-t01'	'LA_kwDOI3pPi88AAAABOy9BUA'	'1d76db'	'NIH, yr1, aim1, task1: MVP for registering metadata in the repository'	'TEST'	'pm.GREI-d-1.1.1'
#287	'IQSS'	'MDEyOk9yZ2FuaXphdGlvbjY3NTIzNw=='	'dataverse-frontend'	'R_kgDOI3pPiw'	'pm.f01-d-y01-a01-t02'	'LA_kwDOI3pPi88AAAABOy9CWQ'	'1d76db'	'NIH, yr1, aim1, task2: Define a cost recovery model for large dataset support'	'TEST'	'pm.GREI-d-1.1.2'
#288	'IQSS'	'MDEyOk9yZ2FuaXphdGlvbjY3NTIzNw=='	'dataverse-frontend'	'R_kgDOI3pPiw'	'pm.f01-d-y01-a02-t01'	'LA_kwDOI3pPi88AAAABOy9DlA'	'1d76db'	'NIH, yr1, aim2, task1: Design and implement integration with controlled voc'	'TEST'	'pm.GREI-d-1.2.1'
#289	'IQSS'	'MDEyOk9yZ2FuaXphdGlvbjY3NTIzNw=='	'dataverse-frontend'	'R_kgDOI3pPiw'	'pm.f01-d-y01-a02-t02'	'LA_kwDOI3pPi88AAAABOy9ErA'	'1d76db'	'NIH, yr1, aim2, task2: Define use cases for DDI-CDI support'	'TEST'	'pm.GREI-d-1.2.2'

def execute_mutation(auth_token_val, query_str, vars_in):
    query_input_params = vars_in
    # print("query_input_params \"{}\"".format(query_input_params))

    headers = {"Authorization": "Bearer " + auth_token_val, "Accept": "application/vnd.github.bane-preview+json"}
    transport = AIOHTTPTransport(url='https://api.github.com/graphql', headers=headers)
    client = Client(transport=transport)
    data = client.execute(query_str, variable_values=query_input_params)
    result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + "\n" +  '<root>' + "\n" +  dict2xml(data, wrap="pages", indent="  ") + "\n" +  '</root>' + "\n"

    return result



# Main
# Get all the items
#   input:
#          query_str - graphql file containing the query
#          vars_in - contains the correct variables for the query to work
#
#  output:
#  prereq: the contents of vars_in and query_str are closely related and are assumed to be correct.
#          When setting vars_in, the code takes advantage of the input having headers and that the headers can be used
#          as keys to the columns.  (This code prolly can be a bit generalized in this area)
#          auth token for github must be set in the environment
# postreq:
#   descr:
#
# e.g runline
# :~/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/api/bin$
# python mutation-update_labels.py --qry ../lib/mutation-update_label.graphql --in_file ../../main/input/2023_04_08-update_label_names.tsv
#

parser = argparse.ArgumentParser(description='query related information')
# ($projectId: ID!, $itemID: ID!) {
parser.add_argument('--qry', dest='query_filename', type=str, help='Name of the query file')
parser.add_argument('--in_file', dest='datafile', type=str, help='XXX')

args = parser.parse_args()

################################################
# get OAUTH token
key = 'GITHUB_TOKEN'
authTokenVal = os.getenv(key, "novalue")

################################################
# read graphql query from file
query_filename = args.query_filename
queryString = load_query(query_filename)

################################################
# read in the data file
datafile = args.datafile
# reader is a list containing the lines of the file
reader = DataReader(datafile)
# issues_dict is a list of dictionaries
issues_dict_list = reader.to_dict()


################################################
# Setup the query variables
# Print the dictionary
for issue in issues_dict_list:
    print(f"  {issue['LabelID']}, {issue['LabelName2']}")
    varsIn = {"itemId": issue['LabelID'].strip("'"), "name": issue['LabelName2'].strip("'")}
    result = execute_mutation(authTokenVal, queryString, varsIn)
    print(result)
    print("-------------")








