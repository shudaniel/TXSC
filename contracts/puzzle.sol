// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

contract Puzzle {
    address payable public owner;
    bool public solved;
    uint public reward;
    bytes32 public diff;
    bytes32 public solution;

    // Convert bytes array to bytes32
    // https://ethereum.stackexchange.com/questions/7702/how-to-convert-byte-array-to-bytes32-in-solidity
    function bytesToBytes32(bytes memory b, uint offset) private pure returns (bytes32) {
        bytes32 out;

        for (uint i = 0; i < 32; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
        }
        return out;
    }

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

    function submitSolution() public payable {
        if (!solved) {
            if (sha256(msg.data) < diff) {
                msg.sender.transfer(reward);
                solution = bytesToBytes32(msg.data, 0);
                solved = true;
            }
            else {
                log0(bytes32("Incorrect"));
            }
        }
        else {
            log0(bytes32("Puzzle already solved"));
        }
    }

}