pragma solidity >= 0.5.0 < 0.6.0;

contract WolframAlphaLog {

    string public temperature;

    constructor(_temperature string)
        public
    {
        temperature = _temperature;

    }


    function update(_temperature string)
        public
    {
        temperature = _temperature;
    }

    function getTemperature() public 
    {
        return temperature;
    }
}