// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

contract Puzzle {
    address payable public owner;
    bool public solved;
    uint public reward;
    bytes32 public diff;
    bytes32 public solution;

    constructor(bytes32 difficulty) public payable {
        owner = msg.sender;
        reward = msg.value;
        solved = false;
        diff = difficulty;
    }

    function updateReward() public payable {
        require(
            owner == msg.sender,
            "Only the owner may update the reward"
        );

        if (!solved) {
            owner.transfer(reward);
            reward = msg.value;
        }
    }

    // @SDTF
    function submitSolution() public payable {
        // For the purposes of reproducing the bug, I will introduce a delay with this big loop

        if (!solved) {
            // For now, I will not use sha256 so I can test this easier
            if (sha256(msg.data) < diff) {
                msg.sender.transfer(reward);
                solution = sha256(msg.data);
                solved = true;
            }
        }
    }

}