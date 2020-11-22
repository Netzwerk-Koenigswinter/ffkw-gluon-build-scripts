#!/usr/bin/env python3

import fileinput
import os
from shutil import copyfile


dmnlst = "domainlist.csv"
masterConfig = "ortschaft.conf"
nameFlag = "Ortschaft"
ssidFlag = "OrtschaftSSID"
out = "Configs"

def asciistring(s):
    s = s.replace(" ", "_")
    s = s.replace("ß", "ss")
    s = s.replace("ö", "oe")
    s = s.replace("ü", "ue")
    s = s.replace("ä", "ae")
    return s.lower()

path = os.path.dirname(__file__)

domainFile = open(path + "/" + dmnlst, 'r')
domains = [v.rstrip() for v in domainFile.readlines()]

if not os.path.exists(path + "/" + out):
    os.makedirs(path + "/" + out)

for i in domains:

    name, ssid = i.split(",")

    newConfPath = path + "/" + out + "/" + asciistring(name) + ".conf"
    print(masterConfig, newConfPath)
    copyfile(path + "/" + masterConfig, newConfPath)

    with fileinput.FileInput(newConfPath, inplace=True) as file:
        for line in file:

            out_line = line.replace(ssidFlag, ssid)
            out_line = out_line.replace(nameFlag.lower(), asciistring(name))
            out_line = out_line.replace(nameFlag, name)

            print(out_line, end='')
