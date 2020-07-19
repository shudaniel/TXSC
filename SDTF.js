/*
    A single domain transactional function (SDTF) is one with no asynchronous callbacks
    Upon creation of a contract, TXSC will append a requirement to check that the attributes that the 
    user observed upon calling the function matches the attributes present.
    
    This framework will provide a way to create and deploy contracts, and TXSC will append these requirements to
    every SDTF
*/
// const Contract = require('web3-eth-contract');
// const solc = require('solc');

// /**
//  * 
//  * @method Contract
//  * @constructor
//  * @param {Array} jsonInterface 
//  * @param {String} address 
//  * @param {Object} options 
//  */
// function createContract(jsonInterface, address = null, options = {}) {
//     var contract = new Contract(jsonInterface, address, options);
    

// }
import parser from 'solidity-parser-antlr';

function parseContract(filename) {
    var fr=new FileReader(); 
    fr.readAsText(filename); 
}

parseContract("C:\\Users\\Daniel Shu\\TXSC\\contracts\\puzzle.sol");
