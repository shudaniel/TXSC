import sys
import re
import pprint
from solidity_parser import parser

# https://etherscan.io/apis#contracts
# API KEY: 2KTYPZPRTYYAJD4FYBV93HCTJR2SK9D8ZU

def extract_state_variables(body, statevariables):
    '''
        Recursively scan the body and find all identifiers that are also state variables
        According to this post: https://ethereum.stackexchange.com/questions/37716/explicitly-refer-to-state-variables-instead-of-local-variables-with-the-same-nam
        The state variables cannot have same name as local variables, so I will use this assumption when looking for variables.
        Return set of all the state variables used in the body
    '''
    if body is None:
        return set()

    used_variables = set()
    if body.get('type') == "Identifier":
        if body.get('name') in statevariables:
            used_variables.add(body.get('name'))

    for key in body:
        v = body[key]
        if isinstance(v, dict):
            for result in extract_state_variables(v, statevariables):
                used_variables.add(result)
        elif isinstance(v, list):
            for d in v:
                for result in extract_state_variables(d, statevariables):
                    used_variables.add(result)

    return used_variables


def apply_SDTF(input_filename, output_filename):
    # This script will append on additional parameters to each SDTF marked function. 
    # The variable names will equal {variable_prefix}_{state variable name}
    # The new parameters will be added to the front of the parameter list and in alphabetical order
    # Only function definitions that are immediately proceded by the tag @STDF in a comment will be considered
    sourceUnit = parser.parse_file(input_filename)

    f = open(input_filename, "r")
    contract = f.read()
    f.close()

    variable_prefix = "readset"

    for child in sourceUnit["children"]:
        # If there is more than one contract definition within this file, then this script
        # assumes that every function between the two contracts has a different name
        
        if child["type"] == "ContractDefinition":
            subnodes = child['subNodes']

            statevariables = dict()

            # Iterate once through to grab all the statevariables
            for node in subnodes:
                nodetype = node['type']
                if nodetype == 'StateVariableDeclaration':
                    for variable in node['variables']:
                        if variable['visibility'] == 'public':
                            # At the moment, this framework will only work on state variables that are of type : ElementaryTypeName
                            if variable['typeName']['type'] == "ElementaryTypeName":
                                statevariables[variable['name']] = variable["typeName"]["name"]

            # Iterate again to examine each function definition
            for node in subnodes:
                nodetype = node['type']
                if nodetype == "FunctionDefinition" and not node['isConstructor']:
                    # Identify all the statevariables that are used in each function
                    body = node['body']
                    name = node['name']
                    used_state_variables = list(extract_state_variables(body, statevariables.keys()))
                    used_state_variables.sort()
                    if len(used_state_variables) > 0:

                        # First, get the list of parameters
                        definition_re = r"@SDTF\s*function\s+" + name + r"\("
                        functiondefinitionResult = re.search(definition_re, contract)
                        if functiondefinitionResult is None:
                            continue
                        
                        functiondefinition = functiondefinitionResult.group()

                        # Create the require statement and updated parameter list
                        requires = "require("
                        for idx, variable in enumerate(used_state_variables):
                            if idx > 0:
                                requires += " && "
                                functiondefinition += ","
                            requires += variable + " == " + variable_prefix + "_" + variable
                            functiondefinition += statevariables[variable] + " " + variable_prefix + "_" + variable

                        requires += ", \"Readset of contract data at time of calling is stale\");" 

                        # Append parameters to this function. 
                        # Also check if there are any parameters in this function already. If so, then you will need to append a comma to the end of the new functiondefinition
                        if len(node['parameters']['parameters']) > 0:
                            functiondefinition += ","

                        # Add the requires statement
                        old_definition = re.search( r"function\s+" + name + r"\(.*\).*\{", contract ).group()
                        contract = re.sub(r"function\s+" + name + r"\(.*\).*\{",  old_definition + "\n" + requires + "\n",contract)

                        # Update the parameter list
                        contract = re.sub(definition_re, functiondefinition, contract)
    
    # Write the new contract into a file
    f = open(output_filename, "w")
    f.write(contract)
    f.close
    

if __name__ == '__main__':
    apply_SDTF(sys.argv[1], sys.argv[2])