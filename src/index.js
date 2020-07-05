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
}

main();