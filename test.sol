// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.6.0;
import "./provableAPI.sol";

import "logtest.sol";
contract BlockKing is usingProvable {
BlockKingLog private BlockKingLoglogs;

    address payable public owner;
    address payable public king;
    address payable public warrior;
    uint public kingBlock;
    uint public warriorBlock;
    // uint public warriorGold;
    uint public reward;
    uint public minBet;

    mapping(address => uint) pendingWithdrawls;

    event LogNewRandomNumber(string description);

    constructor(uint minimum) public payable {
        minBet = minimum;
        owner = msg.sender;
        king = msg.sender;
        warrior = msg.sender;
        warriorBlock = block.number;
        reward = msg.value;
        kingBlock = block.number;
    }

    // @CDTF ENTER
    function enter() public payable {
BlockKingLoglogs = BlockKingLog(owner,king,warrior,kingBlock,warriorBlock,reward,minBet)

        require (
            msg.value >= minBet,
            'This function requires the value to be greater than minBet'
        );
        warrior = msg.sender;
        warriorBlock = block.number;
        // warriorGold = msg.value;
        // reward += msg.value;

        bytes32 myid = provable_query("WolframAlpha", "random number between 1 and 9");


        
    }

    function __callback(bytes32 myid, string memory result) public {
        require (msg.sender == provable_cbAddress(),
            'This function can only be accessed by the provable callback address'
        );
        emit LogNewRandomNumber(result);
        uint randomNumber = uint(uint8(bytes(result)[0])) - 48;

        // Get the first digit of the warriorBlock
        uint singleDigitBlock = warriorBlock;
        if (singleDigitBlock == 0) {
            singleDigitBlock = 1;
        }
        while (singleDigitBlock >= 10) {
            singleDigitBlock /= 10;
        }
        if (randomNumber == singleDigitBlock) {
            // Give 50% to the owner and 50% to the new block king
           king = warrior;
           kingBlock = warriorBlock;
            
        //    uint rewardToTransfer1 = reward / 2;
        //    uint rewardToTransfer2 = reward - rewardToTransfer1;
           
        //    pendingWithdrawls[owner] = rewardToTransfer1;
        //    pendingWithdrawls[king] = rewardToTransfer2;
        //    reward = 0;
        }
        else {

        }
        
        
    }
    
    // function withdraw() public payable {
    //     uint amount = pendingWithdrawls[msg.sender];
    //     pendingWithdrawls[msg.sender] = 0;
    //     msg.sender.transfer(amount);
    // }
}
