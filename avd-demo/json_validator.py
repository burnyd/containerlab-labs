#!/usr/local/bin/python3.7

import json,os 
from jsonschema import validate

path = os.getcwd()

with open(path +'/intended/structured_configs/schema.json') as f:
    data = json.load(f)

with open(path +'/intended/structured_configs/DC1-LEAF1A.json') as r:
    switch = json.load(r)

print("This is the output for the switchplatform " + str(switch['switch_platform']))
print("This is the type of object")
print(type(switch['switch_platform']))
#Validate that the switch type is of 7280R & a integer
validate(instance={"switch_platform" : switch['switch_platform']}, schema=data)


