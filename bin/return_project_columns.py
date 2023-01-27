# An example to get the remaining rate limit using the Github GraphQL API.
# https://gist.github.com/gbaman/b3137e18c739e0cf98539bf4ec4366ad#file-graphql_example-py

import requests
import os

key = 'AUTH_TKN'
value = os.getenv(key, "novalue")
# print("headers {} - {}".format(key, value))

headers = {'Authorization': 'Bearer ' + value}
print("headers - {}".format(headers))


# A simple function to use requests.post to make the API call. Note the json= section.
def run_query(queryStr):
    request = requests.post('https://api.github.com/graphql', json={'query': queryStr}, headers=headers)

    if request.status_code == 200:
        return request.json()
    else:
        raise Exception("Query failed to run by returning code of {}. {}".format(request.status_code, query))


# using: https://www.onegraph.com/graphiql
query = """
{ organization(login: "thisaintwork") 
  { projectsV2(first: 20) 
    { nodes 
      { (closed: "True")
        id
        number
        title
        closed
      }
    }
    id
    email
  }
}

"""
#query { organization(login: ""$organizationName"") { projectsV2(first: 100) { edges { node { id } } } } }"
result = run_query(query)  # Execute the query
# orgnzn = result["github"]["organization"]
print("xxx - {}".format(result))
