# An example to get the remaining rate limit using the GitHub GraphQL API.

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



class DataDict:
    def __init__(self, file_path):
        self.data = {}
        with open(file_path) as f:
            for line in f:
                fields = line.strip().split('\t')
                key1 = fields[0]
                key2 = fields[1]
                data_dict = {
                    "repo": fields[0],
                    "ID": fields[1],
                    "type": fields[2],
                    "oldlabel": fields[3],
                    "newlabel": "none"
                }
                if key1 not in self.data:
                    self.data[key1] = {}
                    self.data[key1][key2] = {}
                self.data[key1][key2] = data_dict
    def print_items(self, dict_name):
        for key1, sub_dict in self.data.items():
            for key2, data_dict in sub_dict.items():
                outstr = ""
                for key, value in data_dict.items():
                    if key == "oldlabel":
                        outstr = outstr + "\t" + value + "\t" + dict_name[value]
                    else:
                        outstr = outstr + "\t" + value
                print(f" {outstr}")

class OldToNewLabel:
    def __init__(self):
        self.data = {}
        self.data["'NIH_OTA_DC'"] = "'NIH OTA DC'"
        self.data["'NIH_OTA:_1_1_1'"] = "'pm.f01-d-y01-a01-t01'"
        self.data["'NIH_OTA:_1_2_1'"] = "'pm.f01-d-y01-a02-t01'"
        self.data["'NIH_OTA:_1_2_2'"] = "'pm.f01-d-y01-a02-t02'"
        self.data["'NIH_OTA:_1_3_1'"] = "'pm.f01-d-y01-a03-t01'"
        self.data["'NIH_OTA:_1_3_2'"] = "'pm.f01-d-y01-a03-t02'"
        self.data["'NIH_OTA:_1_4_1'"] = "'pm.f01-d-y01-a04-t01'"
        self.data["'NIH_OTA:_1_5_1'"] = "'pm.f01-d-y01-a05-t01'"
        self.data["'NIH_OTA:_1_6_1'"] = "'pm.f01-d-y01-a06-t01'"
        self.data["'NIH_OTA:_1_6_2'"] = "'pm.f01-d-y01-a06-t02'"
        self.data["'NIH_OTA:_1_7_1_(reArchitecture)'"] = "'pm.f01-d-y01-a07-t01'"


#data_dict = DataDict("../../main/input/repo-add_label_to_these_issues_or_prs.txt")
newlabels = OldToNewLabel()

#print(data_dict.data)
#data_dict.data["'IQSS/dataverse-frontend'"]["'28'"]["newlabel"] = newlabels.data(data_dict.data["'IQSS/dataverse-frontend'"]["'28'"]["oldlabel"])
#print(data_dict.data["'IQSS/dataverse-frontend'"]["'28'"]["newlabel"])
#print(data_dict.data["'IQSS/dataverse-frontend'"]["'28'"]["oldlabel"])
#print(newlabels.data[data_dict.data["'IQSS/dataverse-frontend'"]["'28'"]["oldlabel"]])
#data_dict.print_items(newlabels.data)

file_path="../../main/input/repo-add_label_to_these_issues_or_prs.txt"
with open(file_path) as f:
    for line in f:
        fields = line.strip().split('\t')
        print (f"{fields[0]}\t{fields[1]}\t{fields[2]}\t{fields[3]}\t{newlabels.data[fields[3]]}")


