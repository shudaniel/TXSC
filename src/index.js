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
  const address = '8F4453CF3190cc99fB724E9cF978BfE68C51E8D1';

  // To 
  const box = loader.fromArtifact('Test', address);
  var diff;
  var owner;
  var reward;
  var solution;
  var solved;

  await box.methods.solved().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log(result);
    solved = result;
    });

  await box.methods.owner().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log(result);
    owner = result;
    });
  await box.methods.reward().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log(result);
    reward = result;
    });

  console.log(owner, reward, solved);
  await box.methods.updateReward(owner, reward, solved)
    .send({ from: accounts[0], value: 40e18 , gas: 50000, gasPrice: 1e6 });

  
  await box.methods.solved().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    solved = result;
    });
  await box.methods.solution().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    solution = result;
    });
  await box.methods.diff().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    diff = result;
    });
  await box.methods.reward().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    reward = result;
    });
  // Send a transaction to store() a new value in the Box
  // 1 ether = 1e18 wei

  try {
    box.methods.submitSolution(diff, reward, solution, solved)
      .send({ from: accounts[1], gas: 6721975, gasPrice: 1e6 });

  }
  catch (err) {
    console.log(err.message);
  }
    

}

main();