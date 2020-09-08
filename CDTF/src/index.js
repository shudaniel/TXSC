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
  var balance;

  // Set up web3 object, connected to the local development network, and a contract loader
  const loader = setupLoader({ provider: web3 }).web3;

  // Set up a web3 contract, representing our deployed Box instance, using the contract loader
  const addr = '0xd84401A82e76eD93BDF2Faa502AF915805dCF7B0';
  const contract = loader.fromArtifact('BlockKingModified', addr);
  // To 
  await contract.methods.king().call({ from: accounts[0], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log("King:", result);
    });
  await contract.methods.kingBlock().call({ from: accounts[0], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log("KingBlock:", result);
    });
  await contract.methods.warrior().call({ from: accounts[0], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log("Warrior:", result);
    });
  await contract.methods.warriorBlock().call({ from: accounts[0], gas: 6721975, gasPrice: 1e6 }).then(function(result){
    console.log("WarriorBlock:", result);
    });
  balance = await web3.eth.getBalance(addr);
  console.log("Balance:", balance);



  // contract.methods.enter().send({ from: accounts[1], value: 1e18 , gas: 6721975, gasPrice: 1e6 })
  // contract.methods.enter().send({ from: accounts[2], value: 1e18 , gas: 6721975, gasPrice: 1e6 })
  // contract.methods.enter().send({ from: accounts[3], value: 1e18 , gas: 6721975, gasPrice: 1e6 })
  // contract.methods.warrior().call({ from: accounts[0], gas: 6721975, gasPrice: 1e6 }).then(function(result){
  //   console.log("Warrior:", result);
  //   });

  // balance = await web3.eth.getBalance(addr);
  // console.log("Balance:", balance);
}

main();