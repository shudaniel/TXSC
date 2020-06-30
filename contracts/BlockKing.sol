// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

contract BlockKing {
    address payable public king;
    address payable public warrior;
    uint public kingBlock;
    uint public warriorBlock;
    uint public warriorGold;
    uint public randomNumber;
    uint public reward;
    uint public minBet;

    mapping(uint => address) public players;

    constructor(uint minimum) public payable {
        minBet = minimum;
        king = msg.sender;
        reward = msg.value;
        kingBlock = block.number;
    }   

    // function enter() public {
    //     if (msg.value > minBet) {
    //         warrior = msg.sender;
    //         warriorGold = msg.value;
    //         warriorBlock = block.number;


    //     }
    // }
}
