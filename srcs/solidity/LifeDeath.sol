pragma solidity >=0.4.22 <0.7.0;

contract InsuranceContract {

    struct Sender {
        address sender;
    }
    
    struct Receiver {
        uint idRequest;
        uint amount;
        address receptor;
    }

    address public manager;
    Receiver public receiver;
    Sender sender;
    uint requestID;
    Receiver[] listReceptor;

    mapping(address => Sender) public senders;
    
    mapping(address => Receiver[]) public receivers;
    
    address [] public senderList;

    constructor() public {
       manager = msg.sender;
    }
    
    function addRequest(
        address addressReceptor
        ) 
        public payable 
        returns (uint idRequest)
        {
        
        require(msg.value > .01 ether);
        senders[ msg.sender].sender = msg.sender;
        
        receiver.amount = msg.value;
        receiver.receptor = addressReceptor;
        requestID = requestID + 1;
        receiver.idRequest = requestID;
        receivers[ msg.sender ].push(receiver);
        
        
        bool isFound = false;
        for (uint i=0; i<senderList.length; i++) { 
            if (senderList[i] == msg.sender) {
                isFound = true;
            }
        }
        if (!isFound) {
            senderList.push(msg.sender);
        }
        
        return requestID;
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function payAmountProcess(address senderAddress) public restricted{
        listReceptor = receivers[senderAddress];
        uint arrayLength = listReceptor.length;
        for (uint i=0; i<arrayLength; i++) {
            listReceptor[i].receptor.transfer(listReceptor[i].amount);
        }
        delete receivers[senderAddress];
        delete senders[senderAddress];

    }
}
