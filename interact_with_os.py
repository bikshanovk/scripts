#!/usr/bin/env python3
"""
This is one of the labs scripts
"""

import operator
import re

error = {}
error_csv_path = 'errors.csv'
error_pattern = r"ERROR ([\w ']+)"
syslog_path = 'syslog.log'

user = {}
user_csv_path = 'users.csv'
user_pattern = r"\(([\.\w]+)\)"

with open(syslog_path) as fp:
    line = fp.readline()
    cnt = 1
    while line:
        if re.search(r"INFO ([\w ]*) ", line):
            try:
                status = user[re.search(user_pattern, line).group(1)]
            except KeyError:
                user[re.search(user_pattern, line).group(1)] = {}
                user[re.search(user_pattern, line).group(1)]["INFO"] = 0
                user[re.search(user_pattern, line).group(1)]["ERROR"] = 0
            user[re.search(user_pattern, line).group(1)]["INFO"] += 1

        if re.search(r"ERROR ([\w ]*) ", line):
            try:
                status = user[re.search(user_pattern, line).group(1)]
            except KeyError:
                user[re.search(user_pattern, line).group(1)] = {}
                user[re.search(user_pattern, line).group(1)]["INFO"] = 0
                user[re.search(user_pattern, line).group(1)]["ERROR"] = 0
            user[re.search(user_pattern, line).group(1)]["ERROR"] += 1
            try:
                error[re.search(error_pattern, line).group(1)] += 1
            except KeyError:
                error[re.search(error_pattern, line).group(1)] = 1
        line = fp.readline()
        cnt += 1

#The error dictionary should be sorted by the number of errors from most common to least common.
error = sorted(error.items(), key=operator.itemgetter(1), reverse=True)

#The user dictionary should be sorted by username.
user = sorted(user.items())

with open(error_csv_path, 'w') as csv_file:  # You will need 'wb' mode in Python 2.x
    csv_file.write("%s, %s\n"%("Error", "Count"))
    for key in error:
        csv_file.write("%s, %s\n"%(key[0], key[1]))

with open(user_csv_path, 'w') as csv_file:  # You will need 'wb' mode in Python 2.x
    csv_file.write("%s, %s, %s\n"%("USERNAME", "INFO", "ERROR"))
    for key in user:
        csv_file.write("%s, %s, %s\n"%(key[0], key[1]["INFO"], key[1]["ERROR"]))
