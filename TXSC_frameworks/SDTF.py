import sys
import re
import pprint

from solidity_parser import parser


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

if __name__ == '__main__':

    sourceUnit = parser.parse_file(sys.argv[1])

    f = open(sys.argv[1], "r")
    contract = f.read()
    f.close()

    # This script will append on additional parameters to each SDTF marked function. 
    # The variable names will equal {variable_prefix}_{state variable name}
    variable_prefix = "readset"


    for child in sourceUnit["children"]:
        # If there is more than one contract definition within this file, then this script
        # assumes that every function between the two contracts has a different name
        
        if child["type"] == "ContractDefinition":
            subnodes = child['subNodes']

            statevariables = dict()
            # functiondefinitions = {}  # Mapping of function definition name to list of all the state variables that it uses
            # re_expressions = {}  # Mapping of function definition to the regular expression that will be used to locate it

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
                    used_state_variables = extract_state_variables(body, statevariables.keys())
                    if len(used_state_variables) > 0:

                        # First, get the list of parameters
                        definition_re = r"function\s+" + name + r"\("
                        functiondefinition = re.search(definition_re, contract).group()
                        # The parameter name will be {variable_prefix}_{STATE VARIABLE NAME}


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

                        # functiondefinitions[name] = requires
                        # re_expressions[name] = r"function\s+" + name + r"\(.*\).*\{"

                        # Add the requires statement
                        old_definition = re.search( r"function\s+" + name + r"\(.*\).*\{", contract ).group()
                        contract = re.sub(r"function\s+" + name + r"\(.*\).*\{",  old_definition + "\n" + requires + "\n",contract)

                        # Update the parameter list
                        contract = re.sub(definition_re, functiondefinition, contract)

    pprint.pprint(statevariables)  
    
    # Write the new contract into a file
    f = open(sys.argv[2], "w")
    f.write(contract)
    f.close