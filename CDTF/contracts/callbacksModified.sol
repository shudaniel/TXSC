pragma solidity >= 0.5.0 < 0.6.0;

import "./provableAPI.sol";
import "./callback_log.sol";

contract WolframAlphaModified is usingProvable {

    string public temperature;

    mapping(bytes32 => WolframAlphaLog) private logs;

    event LogNewProvableQuery(string description);
    event LogNewTemperatureMeasure(string temperature);

    function finish(string memory _temperature) private {
        temperature = _temperature;
    }

    function __callback(
        bytes32 _myid,
        string memory _result
    )
        public
    {
        require(msg.sender == provable_cbAddress());
        logs[_myid].update(_result);
        // Do something with the temperature measure...
        finish(logs[_myid].temperature());
        emit LogNewTemperatureMeasure(temperature);
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