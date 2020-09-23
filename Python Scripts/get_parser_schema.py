import pprint
import sys
from solidity_parser import parser

sourceUnit = parser.parse_file(sys.argv[1])
pprint.pprint(sourceUnit)