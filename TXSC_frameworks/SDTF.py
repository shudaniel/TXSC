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
    pprint.pprint(sourceUnit)

    exit(0)

    subnodes = sourceUnit['children'][1]['subNodes']
    statevariables = set()
    functiondefinitions = {}  # Mapping of function definition name to list of all the state variables that it uses
    re_expressions = {}  # Mapping of function definition to the regular expression that will be used to locate it

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
            used_state_variables = extract_state_variables(body, statevariables)
            if len(used_state_variables) > 0:
                # Create the require statement
                requires = "require("
                for idx, variable in enumerate(used_state_variables):
                    if idx > 0:
                        requires += " && "
                    requires += variable + " == msg.data." + variable
                requires += ", \"Readset of contract data at time of calling is stale\");" 

                functiondefinitions[name] = requires
                re_expressions[name] = r"function\s+" + name + r"\(.*\).*\{"

    pprint.pprint(statevariables)  
    pprint.pprint(functiondefinitions)  
    pprint.pprint(re_expressions)
    

    f = open(sys.argv[1], "r")
    contract = f.read()
    f.close()
    
    for name in functiondefinitions:
        requires = functiondefinitions[name]
        
        old_definition = re.search( re_expressions[name], contract ).group()
        contract = re.sub(re_expressions[name],  old_definition + "\n" + requires + "\n",contract)
    # Find all the functions

    f = open(sys.argv[2], "w")
    f.write(contract)
    f.close