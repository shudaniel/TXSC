// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.6.0;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract BlockKing is usingOraclize {
    address payable public owner;
    address payable public king;
    address payable public warrior;
    uint public kingBlock;
    uint public warriorBlock;
    uint public warriorGold;
    uint public randomNumber;
    uint public reward;
    uint public minBet;

    mapping(address => uint) pendingWithdrawls;

    constructor(uint minimum) public payable {
        minBet = minimum;
        owner = msg.sender;
        king = msg.sender;
        reward = msg.value;
        kingBlock = block.number;
    }

    function enter() public payable {
        require (
            msg.value >= minBet,
            'This function requires the value to be greater than minBet'
        );
        warrior = msg.sender;
        warriorGold = msg.value;
        reward += msg.value;
        warriorBlock = block.number;

        bytes32 myid = oraclize_query("WolframAlpha", "random number between 1 and 9");


        
    }

    function __callback(bytes32 myid, string memory result) public {
        require (msg.sender == oraclize_cbAddress(),
            'This function can only be accessed by the callback'
        );
        randomNumber = uint(uint8(bytes(result)[0])) - 48;

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

           uint rewardToTransfer1 = reward / 2;
           uint rewardToTransfer2 = reward - rewardToTransfer1;
           
           pendingWithdrawls[owner] = rewardToTransfer1;
           pendingWithdrawls[king] = rewardToTransfer2;
           reward = 0;
        }
        
    }
    
    function withdraw() public payable {
        uint amount = pendingWithdrawls[msg.sender];
        pendingWithdrawls[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
}
