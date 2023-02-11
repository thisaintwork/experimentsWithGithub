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
page_size = 2
varsit = {"first": page_size}
response = client.execute(query_string, variable_values=varsit)
print("{}".format(response))
print("output - {}".format(response['organization']['projectV2']['items']['totalCount']))


