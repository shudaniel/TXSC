pragma solidity >=0.5.0<0.6.0;
contract BlockKingLog {
	address public owner;
	address payable public king;
	address payable public warrior;
	uint public kingBlock;
	uint public warriorBlock;
	uint public minBet;
constructor (address _owner,address payable _king,address payable _warrior,uint _kingBlock,uint _warriorBlock,uint _minBet) public {
king = _king;
kingBlock = _kingBlock;
minBet = _minBet;
owner = _owner;
warrior = _warrior;
warriorBlock = _warriorBlock;
}

function () external payable {}

function updateowner (address _owner) public {
	owner = _owner;
}
function updateking (address payable _king) public {
	king = _king;
}
function updatewarrior (address payable _warrior) public {
	warrior = _warrior;
}
function updatekingBlock (uint _kingBlock) public {
	kingBlock = _kingBlock;
}
function updatewarriorBlock (uint _warriorBlock) public {
	warriorBlock = _warriorBlock;
}
function updateminBet (uint _minBet) public {
	minBet = _minBet;
}

function sendbalance () public {
	// require(msg.sender == owner, 'Only contract owner can call this');
	msg.sender.send(address(this).balance);
}
}