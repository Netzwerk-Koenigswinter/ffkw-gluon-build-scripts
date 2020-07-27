#!/usr/bin/env python3

import fileinput
import os
from shutil import copyfile


dmnlst = "domainlist"
masterConfig = "ortschaft.conf"
replaceFlag = "Ortschaft"
out = "Configs"

path = os.path.dirname(__file__)

domainFile = open(path + "/" + dmnlst, 'r')
domains = [v.rstrip() for v in domainFile.readlines()]

if not os.path.exists(path + "/" + out):
    os.makedirs(path + "/" + out)

for i in domains:

	newConfPath = path + "/" + out + "/" + i.lower() + ".conf"

	copyfile(path + "/" + masterConfig, newConfPath )
	
	with fileinput.FileInput(newConfPath, inplace=True) as file:
		for line in file:
			print(line.replace(replaceFlag.lower(), i.lower()).replace(replaceFlag, i), end='')
