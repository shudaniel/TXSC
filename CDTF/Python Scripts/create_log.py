import sys
import re
import pprint
from solidity_parser import parser

def create_log_contract(input_filename, output_filename):   
    sourceUnit = parser.parse_file(input_filename)

    f = open("output.txt", "w")
    f.write(sourceUnit)
    f.close()

if __name__ == '__main__':
    create_log_contract(sys.argv[1], sys.argv[2])