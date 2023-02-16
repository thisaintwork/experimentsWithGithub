# An example to get the remaining rate limit using the GitHub GraphQL API.

from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport
import os
import json
from datetime import datetime
import time


#print({}.format(datetime(2008, 11, 10, 17, 53, 59)))



def load_query(query_file):
    with open(query_file) as file:
        return gql(file.read())


# credit: https://til.simonwillison.net/github/graphql-pagination-python
# Get all the items
def get_all_items(auth_token_val, query_str, vars_in):
    has_next_page = True
    start_with = None
    query_input_params = vars_in
    #print("query_input_params \"{}\"".format(query_input_params))

    headers = {"Authorization": "Bearer " + auth_token_val}
    transport = AIOHTTPTransport(url='https://api.github.com/graphql', headers=headers)
    client = Client(transport=transport)
    print(" { \"pages\": [")

    while has_next_page:
        data = client.execute(query_str, variable_values=query_input_params)
        # print results
        #print (", \"pageof\": ")
        #print("totalCount \"{}\"".format(data['organization']['projectV2']['items']['totalCount']))
        #print("hasNextPage \"{}\"".format(data['organization']['projectV2']['items']['pageInfo']['hasNextPage']))
        #print("startCursor \"{}\"".format(data['organization']['projectV2']['items']['pageInfo']['startCursor']))
        #print("endCursor - \"{}\"".format(data['organization']['projectV2']['items']['pageInfo']['endCursor']))
        #print("endCursor - \"{}\"".format(data['organization']['projectV2']['items']['nodes']['content']))
        #print("returned results \"{}\"".format(data))

        print()
        print(json.dumps(data, indent=4))
        print()
        has_next_page = data['organization']['projectV2']['items']['pageInfo']['hasNextPage']
        start_with = data['organization']['projectV2']['items']['pageInfo']['endCursor']
        query_input_params["startWith"] = start_with
        #print("query_input_params \"{}\"".format(query_input_params))
        if has_next_page:
            print(" , ")

    print("] }")

    return


################################################
# get OAUTH token
key = 'AUTH_TKN'
authTokenVal = os.getenv(key, "novalue")

################################################
# read graphql query from file
query_filename = '../input/input_query.graphql'
queryString = load_query(query_filename)

################################################
# Setup the query variables
varsIn = {"loginOrg": "IQSS", "firstFew": 10, "projectNum": 34}

################################################
# Get all the data
get_all_items(authTokenVal, queryString, varsIn)
