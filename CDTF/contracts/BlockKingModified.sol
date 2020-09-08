// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.6.0;
import "./provableAPI.sol";
import "./BlockKingLog.sol";

contract BlockKingModified is usingProvable {
    address public owner;
    address payable public king;
    address payable public warrior;
    uint public kingBlock;
    uint public warriorBlock;
    // uint public warriorGold;
    // uint public reward;
    uint public minBet;

    // mapping(address => uint) pendingWithdrawls;
    mapping(bytes32 => BlockKingLog) private logs;

    event LogNewRandomNumber(string description);

    constructor(uint minimum) public payable {
        minBet = minimum;
        owner = msg.sender;
        king = msg.sender;
        warrior = msg.sender;
        warriorBlock = block.number;
        // reward = msg.value;
        kingBlock = block.number;
    }

    function enter() public payable {
        require (
            msg.value >= minBet,
            'This function requires the value to be greater than minBet'
        );

        bytes32 myid = provable_query("WolframAlpha", "random number between 1 and 9");
        logs[myid] = new BlockKingLog(owner, king, warrior, kingBlock, warriorBlock, minBet);
        logs[myid].updatewarrior(msg.sender);
        // warriorGold = msg.value;
        // reward += msg.value;
        logs[myid].updatewarriorBlock(block.number);

        // Transfer the ether from this message to the log contract
        address(logs[myid]).send(msg.value);

        
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
        // if (true) {
        if (randomNumber == singleDigitBlock) {
            // Give 50% to the owner and 50% to the new block king
           logs[myid].updateking( logs[myid].warrior() );
           logs[myid].updatekingBlock( logs[myid].warriorBlock());

            logs[myid].sendbalance();
            king.send(address(this).balance);
        //    uint rewardToTransfer1 = reward / 2;
        //    uint rewardToTransfer2 = reward - rewardToTransfer1;
           
        //    pendingWithdrawls[owner] = rewardToTransfer1;
        //    pendingWithdrawls[king] = rewardToTransfer2;
        //    reward = 0;
            finish(myid);
        }
        else {
            // Place the money in the pot
            logs[myid].sendbalance();
        }
        
    }
    
    function finish(bytes32 myid) private {
        owner = logs[myid].owner();
        king = logs[myid].king();
        kingBlock = logs[myid].kingBlock();
        warrior = logs[myid].warrior();
        warriorBlock = logs[myid].warriorBlock();
    }
    // function withdraw() public payable {
    //     uint amount = pendingWithdrawls[msg.sender];
    //     pendingWithdrawls[msg.sender] = 0;
    //     msg.sender.transfer(amount);
    // }
}
