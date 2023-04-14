
import os
import argparse
from datetime import datetime
import time
import pandas as pd
import re


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
import pandas as pd


class PMData:
    def __init__(self, file_path):
        self.data = self.read_data(file_path)

    def read_data(self, file_path):
        df = pd.read_csv(file_path, sep='\t')

        # Filter columns based on the criteria
        selected_columns = [col for col in df.columns if not col.startswith("(lbl)") or col.startswith("(lbl)pm")]

        return df[selected_columns]

    def get_data(self):
        return self.data

    def write_data_to_tsv(self, output_file_path, data_to_write):
        data_to_write.to_csv(output_file_path, sep='\t', index=False)

    def filter_data(self, column, query_list):
        if column not in self.data.columns:
            raise ValueError(f"Column '{column}' not found in the dataset.")

        query_regex = '|'.join(re.escape(query) for query in query_list)
        filtered_data = self.data[self.data[column].str.contains(query_regex, na=False)]
        return filtered_data

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
# Usage example
file_path_root = "/home/perftest/DevCode/github-com-mreekie/GitHubProjects/experimentsWithGithub/main/"
file_input_path = "input/2023_04_08-backlog_file_output.tsv"
file_output_path = "wrk/2023_04_08-processed_file.tsv"

pm_data = PMData(file_path_root + file_input_path)
data = pm_data.get_data()
filtered_data = pm_data.filter_data("LatestSprintIssueActiveIn", ["March 1, 2023", "March 15, 2023"])
pm_data.write_data_to_tsv(file_path_root + file_output_path, filtered_data)
print(filtered_data)
