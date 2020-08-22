pragma solidity >= 0.5.0 < 0.6.0;

import "./provableAPI.sol";

contract WolframAlpha is usingProvable {

    string public temperature;

    event LogNewProvableQuery(string description);
    event LogNewTemperatureMeasure(string temperature);

    constructor()
        public
    {
        // OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
        update(); // Update on contract creation...
    }

    function __callback(
        bytes32 _myid,
        string memory _result
    )
        public
    {
        require(msg.sender == provable_cbAddress());
        temperature = _result;
        emit LogNewTemperatureMeasure(temperature);
        // Do something with the temperature measure...
    }

    function update()
        public
        payable
    {
        emit LogNewProvableQuery("Provable query was sent, standing by for the answer...");
        provable_query("WolframAlpha", "temperature in London");
    }
}