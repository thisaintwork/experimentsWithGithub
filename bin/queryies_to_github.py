# An example to get the remaining rate limit using the Github GraphQL API.
# https://gist.github.com/gbaman/b3137e18c739e0cf98539bf4ec4366ad#file-graphql_example-py

import requests
import os
import json

filename = '/home/perftest/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/input/testquery-01.graphql'
# with open(filename, 'r') as file:
# query =  file.read()

# file.close()

# query = '"""' + query + '"""' + "\n"

#print("input - {}".format(query))

key = 'AUTH_TKN'
value = os.getenv(key, "novalue")
# print("headers {} - {}".format(key, value))

headers = {'Authorization': 'Bearer ' + value}


# print("headers - {}".format(headers))


# A simple function to use requests.post to make the API call. Note the json= section.
def run_query(querystr):
    request = requests.post('https://api.github.com/graphql', json={'query': querystr}, headers=headers)

    if request.status_code == 200:
        return request.json()
    else:
        raise Exception("Query failed to run by returning code of {}. {}".format(request.status_code, query))


# The GraphQL query (with a few additional bits included) itself defined as a multi-line string.
query1 = """
{
###
organization(login: "IQSS") {
        projectV2 (number: 34) {
            title
            closed
            number
            createdAt
            updatedAt
            closedAt
            url
            creator {
                login
            }
            # view number 1 is the ordered backlog tab
            field( name: "Status" ) {
                __typename 
                # This will only show the name of the field if it's set to visible
                ... on ProjectV2Field {
                    name
                    id
                }  
                ... on ProjectV2IterationField {
                    name
                }  
                ... on ProjectV2SingleSelectField {
                    name
                    id
                    options {
                        name
                        id
                    }
                }  

            }   
                
        }
        id
        email
        projectsUrl
        login
    }
###
}
"""

parsed_json = run_query(query1)  # Execute the query
#parsed_json = json.loads(ugly_json)
pretty_json = json.dumps(parsed_json, indent=4)
print(pretty_json)


# orgnzn = result["github"]["organization"]
#print("output - {}".format(result))
