pragma solidity >=0.5.0 <0.7.0;

contract Callee {
    uint[] public values;

    function getValue(uint initial) public returns(uint) {
        return initial + 150;
    }
    function storeValue(uint value) public {
        values.push(value);
    }
    function getValues() public returns(uint) {
        return values.length;
    }
}
