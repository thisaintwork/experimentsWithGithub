# An example to get the remaining rate limit using the Github GraphQL API.
# https://gist.github.com/gbaman/b3137e18c739e0cf98539bf4ec4366ad#file-graphql_example-py

import requests

headers = {'Authorization': 'Bearer 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'}


# A simple function to use requests.post to make the API call. Note the json= section.
def run_query(queryStr):
    request = requests.post('https://api.github.com/graphql', json={'query': queryStr}, headers=headers)

    if request.status_code == 200:
        return request.json()
    else:
        raise Exception("Query failed to run by returning code of {}. {}".format(request.status_code, query))


# The GraphQL query (with a few additional bits included) itself defined as a multi-line string.
query = """
{
  viewer {
    login
  }
  rateLimit {
    limit
    cost
    remaining
    resetAt
  }
}
"""

result = run_query(query)  # Execute the query
remaining_rate_limit = result["data"]["rateLimit"]["remaining"]  # Drill down the dictionary
print("Remaining rate limit - {}".format(remaining_rate_limit))
