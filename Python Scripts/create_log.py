import sys
import re
import pprint
from solidity_parser import parser

# According to the solidity parser grammar (https://github.com/solidityj/solidity-antlr4/blob/master/Solidity.g4), 
# these are the ElementaryTypeName:
'''
elementaryTypeName
  : 'address' | 'bool' | 'string' | 'var' | Int | Uint | 'byte' | Byte | Fixed | Ufixed ;

Int
  : 'int' | 'int8' | 'int16' | 'int24' | 'int32' | 'int40' | 'int48' | 'int56' | 'int64' | 'int72' | 'int80' | 'int88' | 'int96' | 'int104' | 'int112' | 'int120' | 'int128' | 'int136' | 'int144' | 'int152' | 'int160' | 'int168' | 'int176' | 'int184' | 'int192' | 'int200' | 'int208' | 'int216' | 'int224' | 'int232' | 'int240' | 'int248' | 'int256' ;

Uint
  : 'uint' | 'uint8' | 'uint16' | 'uint24' | 'uint32' | 'uint40' | 'uint48' | 'uint56' | 'uint64' | 'uint72' | 'uint80' | 'uint88' | 'uint96' | 'uint104' | 'uint112' | 'uint120' | 'uint128' | 'uint136' | 'uint144' | 'uint152' | 'uint160' | 'uint168' | 'uint176' | 'uint184' | 'uint192' | 'uint200' | 'uint208' | 'uint216' | 'uint224' | 'uint232' | 'uint240' | 'uint248' | 'uint256' ;

Byte
  : 'bytes' | 'bytes1' | 'bytes2' | 'bytes3' | 'bytes4' | 'bytes5' | 'bytes6' | 'bytes7' | 'bytes8' | 'bytes9' | 'bytes10' | 'bytes11' | 'bytes12' | 'bytes13' | 'bytes14' | 'bytes15' | 'bytes16' | 'bytes17' | 'bytes18' | 'bytes19' | 'bytes20' | 'bytes21' | 'bytes22' | 'bytes23' | 'bytes24' | 'bytes25' | 'bytes26' | 'bytes27' | 'bytes28' | 'bytes29' | 'bytes30' | 'bytes31' | 'bytes32' ;

Fixed
  : 'fixed' | ( 'fixed' [0-9]+ 'x' [0-9]+ ) ;

Ufixed
  : 'ufixed' | ( 'ufixed' [0-9]+ 'x' [0-9]+ ) ;
'''

def create_log_contract(input_filename, output_filename):   
    sourceUnit = parser.parse_file(input_filename)

    pragma = ""
    for child in sourceUnit["children"]:

        # Get the pragma version
        # It should always be the first line near the top before the contract definitions
        if child["type"] == "PragmaDirective":

            pragma = "pragma solidity " +  child['value'] + ";\n"
        
        elif child["type"] == "ContractDefinition":
            subnodes = child['subNodes']
            statevariables = dict()
            contractName = child['name'] + "Log"

            for node in subnodes:   
                nodetype = node['type']

                # Get all the state variables
                # If it is an address, make note of it it is payable
                if nodetype == 'StateVariableDeclaration':
                    for variable in node['variables']:
                        if variable['visibility'] == 'public':
                            # At the moment, this framework will only work on state variables that are of type : ElementaryTypeName
                            if variable['typeName']['type'] == "ElementaryTypeName":
                                statevariables[variable['name']] = variable["typeName"]["name"]
            
            # Write the log contract
            f = open(output_filename, "w")
            f.write(pragma)
            f.write("contract " + contractName + " {\n")

            for variable in statevariables:
                variabletype = statevariables[variable]
                f.write("\t" + variabletype + " public " + variable + ";\n")

            constructor = "constructor ("
            idx = 0
            for variable in statevariables:
                if idx > 0:
                    constructor += ","
                variabletype = statevariables[variable]
                if variabletype == "string":
                    constructor += variabletype + " memory _" + variable
                else:
                    constructor += variabletype + " _" + variable
                idx += 1

            constructor += ") public {\n"
            for pair in sorted(statevariables.items()):
                variable = pair[0]
                constructor += variable + " = _" + variable + ";\n"
            constructor += "}\n"
            f.write(constructor)

            # Fallback function
            f.write("function () public payable {}\n")

            for variable in statevariables:
                variabletype = statevariables[variable]
                function = "function update" + variable + " ("
                if variabletype == "string":
                    function += variabletype + " memory _" + variable
                else:
                    function += variabletype + " _" + variable
                function += ") public {\n"
                function += "\t" + variable + " = _" + variable + ";\n"

                function += "}\n"
                f.write(function)
            
            f.write("}")
            f.close()

def apply_CDTF(input_filename, output_filename, logfilename):
    sourceUnit = parser.parse_file(input_filename)
    f = open(input_filename, "r")
    contract = f.read()
    f.close()
  
    for child in sourceUnit["children"]:
        
        if child["type"] == "ContractDefinition":
            subnodes = child['subNodes']
            statevariables = dict()
            contractName = child['name']
            contractLogTypeName = contractName + "Log"
            contractLogVariableName = contractLogTypeName + "logs"

            for node in subnodes:   
                nodetype = node['type']

                # Get all the state variables
                # If it is an address, make note of it it is payable
                if nodetype == 'StateVariableDeclaration':
                    for variable in node['variables']:
                        if variable['visibility'] == 'public':
                            # At the moment, this framework will only work on state variables that are of type : ElementaryTypeName
                            if variable['typeName']['type'] == "ElementaryTypeName":
                                statevariables[variable['name']] = variable["typeName"]["name"]

                elif nodetype == "FunctionDefinition" and not node['isConstructor']:
            
                    name = node['name']
                    body = node['body']

                    
            import_statement = "import \"" + logfilename + "\";"
            # Create the instance variable
            logs_var = contractLogTypeName + " private " + contractLogVariableName + ";"    

            # Insert this at the very start of the contract
            contractdefinition = r"contract\s+" + contractName + r".*{"
            contractdefinitionResult = re.search(contractdefinition, contract).group()
            # Add the contract log 
            contract = re.sub(contractdefinitionResult, import_statement + "\n" + contractdefinitionResult + "\n" + logs_var + "\n", contract)


            cdtf_enter_re = r"@CDTF\s+ENTER\s*function.+\(.*\).*{"

            cdtf_enter = re.search(cdtf_enter_re, contract)
            if cdtf_enter is None:
                # There is no cdtf entrance
                continue


            # First, find the @CDTF ENTER tag. That indicates where to create the log contract
            contract_creation = contractLogVariableName + " = " + contractLogTypeName + "(" 
            first = True
            for var in statevariables:
                if not first:
                    contract_creation += ","
                else:
                    first = False
                contract_creation += var

            contract_creation += ")"
            contract = re.sub(cdtf_enter_re, cdtf_enter.group() + "\n" + contract_creation + "\n", contract)


            

            # For every place that contains  @CDTF tag, replce all variable assignemnts and reads to Log updates and reads

    # Write the new contract into a file
    f = open(output_filename, "w")
    f.write(contract)
    f.close
    

if __name__ == '__main__':
    assert(len(sys.argv) > 3)
    create_log_contract(sys.argv[1], sys.argv[2])
    apply_CDTF(sys.argv[1], sys.argv[3], sys.argv[2])