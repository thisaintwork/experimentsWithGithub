############################################
# Setup the query variables
queryString = load_query(query_filename)
page_size = 10
#items_after = "MQ"
#varsit = {"first": page_size, "after": '"' + items_after + '"'}
varsIn = {"loginOrg": "IQSS", "firstFew": page_size}

###########################################
# Send the query
response = client.execute(queryString, variable_values=varsIn)

############################################
# print results
# print results
print("totalCount \"{}\"".format(response['organization']['projectV2']['items']['totalCount']))
print("hasNextPage \"{}\"".format(response['organization']['projectV2']['items']['pageInfo']['hasNextPage']))
print("startCursor \"{}\"".format(response['organization']['projectV2']['items']['pageInfo']['startCursor']))
print("endCursor - \"{}\"".format(response['organization']['projectV2']['items']['pageInfo']['endCursor']))
print("returned results \"{}\"".format(response))

############################################
# Setup the query variables
queryString = load_query(query_filename)
page_size = 2
start_with = response['organization']['projectV2']['items']['pageInfo']['endCursor']
#varsit = {"first": page_size, "after": '"' + items_after + '"'}
varsIn = {"loginOrg": "IQSS", "firstFew": page_size, "startWith": start_with}

############################################
# Send the query
response = client.execute(queryString, variable_values=varsIn)


############################################
# print results
print("totalCount \"{}\"".format(response['organization']['projectV2']['items']['totalCount']))
print("hasNextPage \"{}\"".format(response['organization']['projectV2']['items']['pageInfo']['hasNextPage']))
print("startCursor \"{}\"".format(response['organization']['projectV2']['items']['pageInfo']['startCursor']))
print("endCursor - \"{}\"".format(response['organization']['projectV2']['items']['pageInfo']['endCursor']))
print("returned results \"{}\"".format(response))


############################################
# Setup the query variables
queryString = load_query(query_filename)
page_size = 4
#start_with = response['organization']['projectV2']['items']['pageInfo']['endCursor']
#varsit = {"first": page_size, "after": '"' + items_after + '"'}
varsIn = {"loginOrg": "IQSS", "firstFew": page_size}


############################################
# Send the query
response = client.execute(queryString, variable_values=varsIn)


############################################
# print results
print("totalCount \"{}\"".format(response['organization']['projectV2']['items']['totalCount']))
print("hasNextPage \"{}\"".format(response['organization']['projectV2']['items']['pageInfo']['hasNextPage']))
print("startCursor \"{}\"".format(response['organization']['projectV2']['items']['pageInfo']['startCursor']))
print("endCursor - \"{}\"".format(response['organization']['projectV2']['items']['pageInfo']['endCursor']))
print("returned results \"{}\"".format(response))



#while True:
#    vars = {"first": page_size}
#    response = client.execute(products_query, variable_values=vars)
#    skip += page_size
#    if not response['products']:
#        break




#    if request.status_code == 200:
#        return request.json()
#    else:
#        raise Exception("Query failed to run by returning code of {}. {}".format(request.status_code, querystr))
#

# orgnzn = result["github"]["organization"]
# print("output - {}".format(result))