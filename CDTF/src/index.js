// src/index.js
// https://docs.openzeppelin.com/learn/deploying-and-interacting
const Web3 = require('web3');
const { setupLoader } = require('@openzeppelin/contract-loader');

async function main() {
  // Our code will go here
  // Set up web3 object, connected to the local development network
  const web3 = new Web3('http://localhost:8545');

  // Retrieve accounts from the local node
  const accounts = await web3.eth.getAccounts();
  console.log(accounts);

  // Set up web3 object, connected to the local development network, and a contract loader
  const loader = setupLoader({ provider: web3 }).web3;

  // Set up a web3 contract, representing our deployed Box instance, using the contract loader
  const modified_puzzle_address = 'b8a1278043c89ffc3bf2d46def299d171b7ee9c4';
  const og_puzzle_addr = '41a7b1b5e444352997d6a8a0615296a500bd3b48';

  // To 
  const puzzle_og = loader.fromArtifact('Puzzle', og_puzzle_addr);

}

main();