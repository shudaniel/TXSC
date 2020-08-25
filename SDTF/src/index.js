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
  var diff;
  var owner;
  var reward;
  var solution;
  var solved;

  // First, prove that the problem exists

  puzzle_og.methods.updateReward().send({ from: accounts[0], value: 40e18 , gas: 50000, gasPrice: 1e6,  });
  puzzle_og.methods.submitSolution().send({ from: accounts[1], gas: 6721975, gasPrice: 1e6 });
  puzzle_og.methods.updateReward().send({ from: accounts[0], value: 0 , gas: 50000, gasPrice: 1e6 });

  web3.eth.getBalance(accounts[0]).then(function(result){
    console.log("Account 0 balance (owner):", result);
    });
  web3.eth.getBalance(accounts[1]).then(function(result){
    console.log("Account 1 balance (player):", result);
    });
  await puzzle_og.methods.solved().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log("Solved?:", result);
    });



  const modified_puzzle = loader.fromArtifact('Test', modified_puzzle_address);

  modified_puzzle.methods.solved().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6, name: "hello" }).then(function(result){
    console.log(result);
    solved = result;
    });

  modified_puzzle.methods.owner().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log(result);
    owner = result;
    });
  modified_puzzle.methods.reward().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log(result);
    reward = result;
    });

  console.log(owner, reward, solved);
  await modified_puzzle.methods.updateReward(owner, reward, solved)
    .send({ from: accounts[0], value: 40e18 , gas: 50000, gasPrice: 1e6 });

  
  await modified_puzzle.methods.solved().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    solved = result;
    });
  await modified_puzzle.methods.solution().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    solution = result;
    });
  await modified_puzzle.methods.diff().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    diff = result;
    });
  await modified_puzzle.methods.reward().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    reward = result;
    });
  // Send a transaction to store() a new value in the modified_puzzle
  // 1 ether = 1e18 wei

  await modified_puzzle.methods.solved().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log("Solved?:", result);
    });

  try {
    modified_puzzle.methods.submitSolution(diff, reward, solution, solved)
      .send({ from: accounts[1], gas: 6721975, gasPrice: 1e6 });

    modified_puzzle.methods.updateReward().send({ from: accounts[0], value: 0 , gas: 50000, gasPrice: 1e6 });

    await web3.eth.getBalance(accounts[0]).then(console.log);
    await web3.eth.getBalance(accounts[1]).then(console.log);
    await modified_puzzle.methods.solved().call({ from: accounts[1], gas: 6721975, gasPrice: 1e6 }).then(console.log);

  }
  catch (err) {
    console.log(err.message);
  }
    

}

main();