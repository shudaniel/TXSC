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
  const addr = '24a0ef8b3816abd26b722b414158d1c9078c2eaa';

  // To 
  const contract = loader.fromArtifact('WolframAlpha', addr);
  contract.methods.update().send({ from: accounts[0], value: 1e18 , gas: 6721975, gasPrice: 1e6 })
  // await contract.methods.temperature().call({ from: accounts[0], gas: 6721975, gasPrice: 1e6 }).then(function(result){
  //   console.log("Temperature:", result);
  //   });
}

main();