# An example to get the remaining rate limit using the Github GraphQL API.

from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport
import os

key = 'AUTH_TKN'
value = os.getenv(key, "novalue")

headers = {"Authorization": "Bearer " + value}
transport = AIOHTTPTransport(url='https://api.github.com/graphql', headers=headers)
client = Client(transport=transport)

print("headers {} - {}".format(key, value))
print("headers {}".format(headers))



query_filename = '../input/input_query.graphql'
# read graphql query from file

def load_query(query_filename):
    with open(query_filename) as file:
        return gql(file.read())



query_string = load_query(query_filename)
response = client.execute(query_string)
print(response)



# query = '"""' + query + '"""' + "\n"

# print("input - {}".format(query))



# print("headers - {}".format(headers))


# A simple function to use requests.post to make the API call. Note the json= section.
#def run_query(querystr):
#    request = requests.post('https://api.github.com/graphql', json={'query': querystr}, headers=headers)
#
#
#    if request.status_code == 200:
#        return request.json()
#    else:
#        raise Exception("Query failed to run by returning code of {}. {}".format(request.status_code, querystr))
#

# The GraphQL query (with a few additional bits included) itself defined as a multi-line string.
query1 = """
{
###
#Query1C
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
            items (first: 20) {
                
                totalCount
                nodes {
                    id
                    type 
                    fieldValueByName (name: "Status") {
                        ... on ProjectV2ItemFieldDateValue {
                            date
                        }
                        
                        ... on  ProjectV2ItemFieldIterationValue {
                            id
                        }
                        ... on  ProjectV2ItemFieldLabelValue {
                            labels {
                                totalCount
                                nodes {
                                    name
                                } 
                            }
                        }
                        ... on  ProjectV2ItemFieldMilestoneValue {
                            milestone {
                                title
                            }
                        }
                        ... on  ProjectV2ItemFieldNumberValue {
                            number
                        }
                        ... on  ProjectV2ItemFieldPullRequestValue {
                            pullRequests {
                                totalCount
                            }
                        }
                        ... on  ProjectV2ItemFieldRepositoryValue {
                            repository {
                                name
                            }
                        }
                        ... on  ProjectV2ItemFieldReviewerValue {
                            reviewers(first:20) {
                                totalCount
                            }
                        
                        }
                        ... on  ProjectV2ItemFieldSingleSelectValue {
                            name
                        }
                        ... on  ProjectV2ItemFieldTextValue {
                            text	
                        
                        }
                        ... on  ProjectV2ItemFieldUserValue {
                            users(first:20) {
                                totalCount
                            }
                        }
                    }
                    content {
                        ... on Issue {
                            repository {
                                name
                            }
                            title
                            number
                            url
                            labels (first: 10) {
                              totalCount
                                nodes {
                                    name
                                }
                            }
                        }
                        ... on PullRequest {
                            repository {
                                name
                            }
                            title
                            number
                            url
                            labels (first: 10) {
                              totalCount
                                nodes {
                                    name
                                }
                            }
                        }
                        ... on DraftIssue {
                            title
                        }
                    
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

#parsed_json = run_query(query_string)  # Execute the query
# parsed_json = json.loads(ugly_json)
#pretty_json = json.dumps(parsed_json, indent=4)
#print(pretty_json)

# orgnzn = result["github"]["organization"]
# print("output - {}".format(result))
