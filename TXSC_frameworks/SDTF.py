import sys
import pprint

from solidity_parser import parser

sourceUnit = parser.parse_file(sys.argv[1])
pprint.pprint(sourceUnit)

subnodes = sourceUnit['children'][1]['subNodes']
statevariables = set()
functiondefinitions = {}  # Mapping of function definition name to list of all the state variables that it uses

# Iterate once through to grab all the statevariables
for node in subnodes:
    nodetype = node['type']
    if nodetype == 'StateVariableDeclaration':
        for variable in node['variables']:
            if variable['visibility'] == 'public':
                statevariables.add(variable['name'])

# Iterate again to examine each function definition
for node in subnodes:
    nodetype = node['type']
    if nodetype == "FunctionDefinition" and not node['isConstructor']:
        # Identify all the statevariables that are used in each function
        body = node['body']
        name = node['name']
        functiondefinitions[name] = []

        # https://stackoverflow.com/questions/9807634/find-all-occurrences-of-a-key-in-nested-dictionaries-and-lists



pprint.pprint(statevariables)  