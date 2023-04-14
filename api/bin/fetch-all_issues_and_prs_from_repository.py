

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

class GraphQLFetcher:
    def __init__(self, auth_token_val, query_file, vars_in):
        self.query_file = query_file
        self.auth_token_val = auth_token_val
        self.vars_in = vars_in
        self.has_next_page_path = self.read_variable_from_file( "has_next_page_path")
        self.start_with_path = self.read_variable_from_file( "start_with_path")
        self.query_str = self.load_query()
        self.query_results = ""

    def load_query(self):
        with open(self.query_file) as file:
            return gql(file.read())

    def _get_value_by_path(self, data, path):
        value = data
        for key in path:
            value = value[key]
        return value

    # precond: file_path is a valid path to a file
    #        : The data looks like this:
    #          #has_next_page_path = ["organization", "projectV2", "items", "pageInfo", "hasNextPage"]
    def read_variable_from_file(self, variable_name):
        with open(self.query_file, 'r') as file:
            for line in file:
                if line.startswith('#' + variable_name):
                    path_str = line.split('=')[1].strip()
                    variable_val = json.loads(path_str)
                    return variable_val
        return None

    def get_all_items(self):
        has_next_page = True
        start_with = None
        query_input_params = self.vars_in

        headers = {"Authorization": "Bearer " + self.auth_token_val}
        transport = AIOHTTPTransport(url='https://api.github.com/graphql', headers=headers)
        client = Client(transport=transport)

        results_list = []

        while has_next_page:
            data = client.execute(self.query_str, variable_values=query_input_params)
            results_list.append(dict2xml(data, wrap="pages", indent="  "))
            has_next_page = self._get_value_by_path(data, self.has_next_page_path)
            start_with = self._get_value_by_path(data, self.start_with_path)
            query_input_params["startWith"] = start_with
            print(f"has_next_page: {has_next_page} start_with: {start_with}")

        results_list = ' '.join(results_list)
        self.query_results =  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + "\n" + '<root>' + "\n" + results_list + "\n" + '</root>'

        return self.query_results

    def save_result_to_file(self):
        print(f"Saving result to file: {self.query_file}.xml")
        if self.query_results is None:
            raise ValueError("No result to save. Please fetch the data first using fetch_all_items method.")

        with open(self.query_file + ".xml", "w") as output_file:
            output_file.write(self.query_results)

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
parser.add_argument('--qry', dest='query_filename', type=str, help='Name of the query file')
parser.add_argument('--org', dest='login_org' , type=str, help='XXX')
parser.add_argument('--repo', dest='repo' , type=str, help='XXX')
args = parser.parse_args()
print(args.query_filename)
print(args.login_org)
print(args.repo)


################################################
# get OAUTH token
key = 'GITHUB_TOKEN'
auth_token_val = os.getenv(key, "novalue")
vars_in = {"loginOrg": args.login_org, "firstFew": 100, "repo": args.repo}
fetcher = GraphQLFetcher(auth_token_val, args.query_filename, vars_in)

result = fetcher.get_all_items()
fetcher.save_result_to_file()

