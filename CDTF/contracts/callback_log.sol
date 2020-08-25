pragma solidity >= 0.5.0 < 0.6.0;

contract WolframAlphaLog {

    string public temperature;

    constructor(string memory _temperature)
        public
    {
        temperature = _temperature;

    }


    function update(string memory _temperature)
        public
    {
        temperature = _temperature;
    }
}