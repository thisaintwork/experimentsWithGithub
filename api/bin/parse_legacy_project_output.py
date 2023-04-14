# =================================================================
# Calculate the size of prs and issues in the legacy dataverse project
# =================================================================
#     input var
#              :
#              :
#              :
#    output var:
#
#       precond:
#      postcond:
#

import os
import argparse
from datetime import datetime
import time
import pandas as pd

# =================================================================
# read the output fromwustep-github-project-exporter into a dataframe
# =================================================================
#     input var: file_path
#              :
#              :
#    output var:
#
#       precond: Data is tab delimited.
#      postcond:The data is readinto IssueFrame.
#              : The headers are the first row of data

#
class IssueFrame:
    def __init__(self, file_path):
        self.df = pd.read_csv(file_path, sep='\t')

    def print_issues(self):
        print(self.df.to_string(index=False))

    def clean_labels(self):
        for index, row in self.df.iterrows():
            if not isinstance(row['issue_labels'], str):
                self.df.at[index, 'issue_labels'] = ""
                #row['issue_labels'] = ""

    def add_size_column(self):
        self.clean_labels()
        if not 'size' in self.df.columns:
            self.df['size'] = 0
        for index, row in self.df.iterrows():
            if row['column'] != 'Done 🚀':
                size_num = 0
                label_list = row['issue_labels'].split(',')
                lower_list = [label.lower() for label in label_list]
                size_label = [label.strip() for label in lower_list if 'size:' in label]
                if len(size_label) > 0:
                    size_num = int(size_label[0].split(':')[1].strip())
                self.df.at[index, 'size'] = size_num
                print(f" num:{row['issue_number']} state:{row['column']} s:{size_num}  labels:{row['issue_labels']}")


    def summarize_size_column(self):
        self.clean_labels()
        self.add_size_column()
        #print(f"{self.df['column'].unique()}")
        unique_names = list(self.df['column'].unique())
        for name in unique_names:
            sumnum = self.df[self.df['column'] == name]['size'].sum()
            print(f" column: {name} Sum: {sumnum}")

    def print_issues_by_columns(self):
        self.clean_labels()
        self.add_size_column()
        unique_names = list(self.df['column'].unique())
        for col_name in unique_names:
            filtered_df = self.df[self.df['column'] == col_name]
            print(filtered_df)

INPUTF = "~/DevCode/github-com-mreekie/GitHubProjects/wustep-github-project-exporter/output/export.csv"
print(INPUTF)
parser = argparse.ArgumentParser(description='query related information')
parser.add_argument('--input', dest='input_file', type=str, help='input file path', default=INPUTF)
args = parser.parse_args()


df = IssueFrame(args.input_file)
df.summarize_size_column()
print(f" input file: {args.input_file}")


