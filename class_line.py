class project_issue_row():
	def __init__(self, issue_str = "a | b |c | tag1, tag2"):	
		self.__issue_str = issue_str
		self.__issueID = 12345
		self.__issueDesc = "Description here"
		self.__issueDate = "1/1/2020"
		self.__issueOwner = "TBD"
		self.__issueLabels = []
    
		line_list = str(issue_str).split('|')
		self.__issueID = line_list[0]
		self.__issueDesc = line_list[1]
		self.__issueDate = line_list[2]

		self.__issueLabels = line_list[3].split(',')
		self.__issueLabels = [e.strip() for e in self.__issueLabels ]
   
      
	def get_issueID(self):
		return self.__issueID

	def get_issueDesc(self):
		return self.__issueID

	def get_issueDate(self):
		return self.__issueID

	def get_issueOwner(self):
		return self.__issueOwner
  	
 
line = "345222 | Bug that is a sample | 10-7-2019 | label1, l2, label3"
row = project_issue_row(line)
print(row.get_issueID())