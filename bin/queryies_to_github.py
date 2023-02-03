# An example to get the remaining rate limit using the Github GraphQL API.

from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport
import os
import json

key = 'AUTH_TKN'
value = os.getenv(key, "novalue")

headers = {"Authorization": "Bearer " + value}
transport = AIOHTTPTransport(url='https://api.github.com/graphql', headers=headers)
client = Client(transport=transport)

query_filename = '../input/input_query.graphql'


# read graphql query from file

def load_query(query_filename):
    with open(query_filename) as file:
        return gql(file.read())


query_string = load_query(query_filename)
response = client.execute(query_string)
print(response)
print("output - {}".format(response['organization']['projectV2']['items'['totalCount']))



#    if request.status_code == 200:
#        return request.json()
#    else:
#        raise Exception("Query failed to run by returning code of {}. {}".format(request.status_code, querystr))
#

# orgnzn = result["github"]["organization"]
# print("output - {}".format(result))
