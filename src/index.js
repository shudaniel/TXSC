// src/index.js
// https://docs.openzeppelin.com/learn/deploying-and-interacting
const Web3 = require('web3');
const { setupLoader } = require('@openzeppelin/contract-loader');

async function main() {
  // Our code will go here
  // Set up web3 object, connected to the local development network
  const web3 = new Web3('http://localhost:7545');

  // Retrieve accounts from the local node
  const accounts = await web3.eth.getAccounts();
  console.log(accounts);

  // Set up web3 object, connected to the local development network, and a contract loader
  const loader = setupLoader({ provider: web3 }).web3;

  // Set up a web3 contract, representing our deployed Box instance, using the contract loader
  const address = '0xE0E94479cE527C04Ff485BcFAc98ded13733592a';

  const box = loader.fromArtifact('Puzzle', address);
  // Send a transaction to store() a new value in the Box
  // 1 ether = 1e18 wei
  // await box.methods.updateReward()
  //   .send({ from: accounts[0], value: 40e18 , gas: 50000, gasPrice: 1e6 });

  try {
    box.methods.submitSolution()
      .send({ from: accounts[1], gas: 6721975, gasPrice: 1e6 });

    box.methods.updateReward()
      .send({ from: accounts[0], value: 0 , gas: 50000, gasPrice: 1e6 });
  }
  catch (err) {
    console.log(err.message);
  }

}

main();