// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;
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

    mapping(bytes32 => address payable) public players;
    mapping(bytes32 => uint) public player_blocks;

    constructor(uint minimum) public payable {
        minBet = minimum;
        owner = msg.sender;
        king = msg.sender;
        reward = msg.value;
        kingBlock = block.number;
    }

    function enter() public payable {
        if (msg.value > minBet) {
            warrior = msg.sender;
            warriorGold = msg.value;
            reward += msg.value;
            warriorBlock = block.number;

            bytes32 myid = oraclize_query("WolframAlpha", "random number between 1 and 9");
            players[myid] = msg.sender;
            player_blocks[myid] = block.number;

        }
    }

    function __callback(bytes32 myid, string memory result) public {
        require (msg.sender == oraclize_cbAddress(),
            'This function can only be accessed by the callback'
        );
        randomNumber = uint(uint8(bytes(result)[0])) - 48;

        // Get the first digit of the warriorBlock
        uint singleDigitBlock = warriorBlock;
        while (singleDigitBlock >= 10) {
            singleDigitBlock /= 10;
        }
        if (randomNumber == singleDigitBlock) {
            // Give 50% to the owner and 50% to the new block king
           king = players[myid];
           kingBlock = player_blocks[myid];

           uint rewardToTransfer1 = reward / 2;
           uint rewardToTransfer2 = reward - rewardToTransfer1;
           owner.transfer(rewardToTransfer1);
           king.transfer(rewardToTransfer2);
           reward = 0;
        }
        
    }
}
