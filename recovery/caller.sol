pragma solidity >=0.5.0 <0.7.0;

contract Caller {
    function someAction(address addr) public returns(uint) {
        Callee c = Callee(addr);
        return c.getValue(100);
    }
    
    function storeAction(address addr) public returns(uint) {
        Callee c = Callee(addr);
        c.storeValue(100);
        return c.getValues();
    }
    
    function someUnsafeAction(address addr) public {
        addr.call(bytes4(keccak256("storeValue(uint256)")), 100);
    }
}
/*
    At the bottom, you can see the Callee interface, mirroring the function signatures
    of the contract behind it. This interface could also be defined in another .sol file
    and imported, to keep things more cleanly separated.
*/
contract Callee {
    function getValue(uint initialValue) public returns(uint);
    function storeValue(uint value) public;
    function getValues() returns(uint) public;
}
