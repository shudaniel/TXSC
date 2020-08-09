pragma solidity >=0.5.0 <0.7.0;

contract Log {
    struct Request {
        uint data_original;
        uint data;
        function(uint) external callback;  // Upon completion, call this function to unlock the resources
    }

    uint private counter;
    mapping( address => bool ) accessors;  // Fill these with the known addresses of contracts that need to access this
    mapping( uint => Request ) private requests;
    event NewRequest(uint);
    bool private completed;

    constructor(address[] memory _accessors) public {
        // Upon creation, provide a list of addresses that may access this block
        for (uint i = 0; i < _accessors.length; ++i) {
            accessors[_accessors[i]] = true;
        }
    }

    function insert(uint data, function(uint) external callback) public {
        require(accessors[msg.sender] && !completed, 'Do not have access to this resource');
        counter += 1;
        requests[counter] = Request(data, data, callback);
        emit NewRequest(counter);
    }

    function update(uint requestID, uint data) public {
        require(accessors[msg.sender] && !completed, 'Do not have access to this resource');
        requests[requestID].data = data;
    }

    function request(uint requestID) public {
        // Here goes the check that the reply comes from a trusted source
        require(accessors[msg.sender] && !completed, 'Do not have access to this resource');
        emit NewRequest(requests[requestID].data);
        // requests[requestID].callback(response);
    }

    function reset(uint requestID) public {
        require(accessors[msg.sender] && !completed, 'Do not have access to this resource');
        requests[requestID].data = requests[requestID].data;
    }

    function finish(uint requestID) public {
        require(accessors[msg.sender] && !completed, 'Do not have access to this resource');
        requests[requestID].callback(requests[requestID].data);
        completed = true;
    }
}