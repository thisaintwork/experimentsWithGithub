# An example to get the remaining rate limit using the GitHub GraphQL API.

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


def load_query(query_file):
    with open(query_file) as file:
        return gql(file.read())


# credit: https://til.simonwillison.net/github/graphql-pagination-python
# Get all the items
#   input: auth token for github
#          query_str - graphql file containing the query
#          vars_in - contains the correct variables for the query to work
#
#  output:
#  prereq: vars_in and query_str are closely related and are assumed to be coorect.
# postreq:
#   descr:
#
#

def get_all_items(auth_token_val, query_str, vars_in):
    has_next_page = True
    start_with = None
    query_input_params = vars_in
    # print("query_input_params \"{}\"".format(query_input_params))

    headers = {"Authorization": "Bearer " + auth_token_val}
    transport = AIOHTTPTransport(url='https://api.github.com/graphql', headers=headers)
    client = Client(transport=transport)
    #print(" { \"pages\": [")
    json_result = " { \"pages\": ["
    results_list = []

    while has_next_page:
        data = client.execute(query_str, variable_values=query_input_params)
        results_list.append(dict2xml(data, wrap="pages", indent="  "))
        has_next_page = data['organization']['projectV2']['items']['pageInfo']['hasNextPage']
        start_with = data['organization']['projectV2']['items']['pageInfo']['endCursor']
        query_input_params["startWith"] = start_with

    results_list = ' '.join(results_list)
    result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + '<root>' + results_list + '</root>'

    return result

def execute_mutation(auth_token_val, query_str, vars_in):
    query_input_params = vars_in
    # print("query_input_params \"{}\"".format(query_input_params))

    headers = {"Authorization": "Bearer " + auth_token_val}
    transport = AIOHTTPTransport(url='https://api.github.com/graphql', headers=headers)
    client = Client(transport=transport)
    #print(" { \"pages\": [")
    json_result = " { \"pages\": ["
    results_list = []

    data = client.execute(query_str, variable_values=query_input_params)
    results_list.append(dict2xml(data, wrap="pages", indent="  "))

    result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + '<root>' + results_list + '</root>'

    return result



# Main
# Get all the items
#   input: auth token for github
#          query_str - graphql file containing the query
#          vars_in - contains the correct variables for the query to work
#
#  output:
#  prereq: vars_in and query_str are closely related and are assumed to be coorect.
# postreq:
#   descr:
#
#

parser = argparse.ArgumentParser(description='query related information')
# ($projectId: ID!, $itemID: ID!) {
parser.add_argument('--qry', dest='query_filename', type=str, help='Name of the query file')
parser.add_argument('--prjId', dest='projectId' , type=int, help='XXX')
parser.add_argument('--itemId', dest='itemID' , type=str, help='XXX')
args = parser.parse_args()
#print(args.query_filename)

################################################
# get OAUTH token
key = 'GITHUB_TOKEN'
authTokenVal = os.getenv(key, "novalue")

################################################
# read graphql query from file
query_filename = args.query_filename
projectId= args.projectId
itemID = args.itemID
queryString = load_query(query_filename)

################################################
# Setup the query variables
#varsIn = {"loginOrg": "IQSS", "firstFew": 100, "projectNum": 34}
varsIn = {"projectId": $projectId, "itemID": itemID}

################################################
# Get all the data
result = execute_mutation(authTokenVal, queryString, varsIn)
print(result)

