# -*- coding: utf-8 -*-
"""
Created on Fri Apr  3 19:44:15 2020

@author: Marc Lacroix
"""

# Read CaseID, Description, Date, Tags[] list

import random


###################################################################
################### Create a test file of random data  ############
###################################################################
outfile = open("MikeData.txt", "w")
N = 7
for i in range(N):
    CaseIDvar = "CaseID" + str(i + 1)
    outfile.write(CaseIDvar + " | ")
    outfile.write("Description for " + CaseIDvar + " | ")

    month = random.randint(1, 12)
    day = random.randint(1, 28)
    DateVar = str(month) +'-' + str(day) + '-' +'2019'  
    outfile.write(DateVar + " | ")

    Num_Of_Tags = random.randint(1, 5)

    for tag in range(Num_Of_Tags):
        tagtype = (10*tag+1) + random.randint(0, 2) 
        TagVar = "TagType" + str(tagtype)
        outfile.write(TagVar)
        if tag < Num_Of_Tags - 1:
            outfile.write(", ")
 
    if  i < N - 1:
        outfile.write("\n")
outfile.close()
############################################################################



###################################################################
#######################  Read file of data     ####################
#################  into structure, print to screen     ############
###################################################################

infile = open("MikeData.txt", "r")

line_list = []
for line in infile:

    row_list = []
    line_list = str(line).split('|')
    for i in range(len(line_list)):
        row_list.append( line_list[i].strip()    )


    # row_list[0] is the CaseID
    # row_list[1] is the Description
    # row_list[2] is the date
#    print(row_list[0:2], end='')

    # row_list[3] is the tags[] list
    # use split(',') and strip() to convert comma separated list to list of strings
    tags_list = row_list[3].split(',')
    tags_list = [e.strip() for e in tags_list]
#    print(tags_list)

    row_list[3] = tags_list
    print(row_list)


infile.close()

