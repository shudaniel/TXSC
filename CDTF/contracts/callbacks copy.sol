pragma solidity >= 0.5.0 < 0.6.0;

import "github.com/provable-things/ethereum-api/provableAPI.sol";
import "./callback_log.sol"

contract WolframAlpha is usingProvable {

    string public temperature;

    mapping(bytes32 -> WolframAlphaLog) private logs;

    event LogNewProvableQuery(string description);
    event LogNewTemperatureMeasure(string temperature);

    // constructor()
    //     public
    // {
    //     // OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
    //     update(); // Update on contract creation...
    // }

    function finish(string _temperature) private {
        temperature = _temperature
    }

    function __callback(
        bytes32 _myid,
        string memory _result
    )
        public
    {
        require(msg.sender == provable_cbAddress());
        logs[_myid].update(_result);
        emit LogNewTemperatureMeasure(temperature);
        // Do something with the temperature measure...
        finish(logs[_myid].getTemperature());
    }

    function update()
        public
        payable
    {
        emit LogNewProvableQuery("Provable query was sent, standing by for the answer...");
        WolframAlphaLog newLog  = new WolframAlphaLog(temperature);
        bytes32 myid = provable_query("WolframAlpha", "temperature in London");
        logs[myid] = newLog;
    }
}