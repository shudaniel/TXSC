pragma solidity >=0.5.0<0.6.0;
contract BlockKingLog {
	address public owner;
	address public king;
	address public warrior;
	uint public kingBlock;
	uint public warriorBlock;
	uint public reward;
	uint public minBet;
constructor (address _owner,address _king,address _warrior,uint _kingBlock,uint _warriorBlock,uint _reward,uint _minBet) public {
king = _king;
kingBlock = _kingBlock;
minBet = _minBet;
owner = _owner;
reward = _reward;
warrior = _warrior;
warriorBlock = _warriorBlock;
}
function () public payable {}
function updateowner (address _owner) public {
	owner = _owner;
}
function updateking (address _king) public {
	king = _king;
}
function updatewarrior (address _warrior) public {
	warrior = _warrior;
}
function updatekingBlock (uint _kingBlock) public {
	kingBlock = _kingBlock;
}
function updatewarriorBlock (uint _warriorBlock) public {
	warriorBlock = _warriorBlock;
}
function updatereward (uint _reward) public {
	reward = _reward;
}
function updateminBet (uint _minBet) public {
	minBet = _minBet;
}
}