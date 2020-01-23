pragma solidity >=0.4.22 <0.7.0;

contract Todesvertrag {

    
    struct Antrag {
        string nachName;
        string vorName;
        uint idAntrag;
        uint geburtsDatum;
        uint todesDatum;
        uint beitrag;
        address empfaenger;
    }
    
    address public manager;
    Antrag public request;
    
    mapping(address => Antrag[]) requests;
    // Antrag[] public antragList;
    
    constructor() public {
       manager = msg.sender;
    }

    
    
    function addRequest(
        string nachName, 
        string vorName, 
        uint geburtsDatum, 
        address empfaenger
        ) 
        public payable 
        returns (uint idAntrag)
        {
        
        require(msg.value > .01 ether);
        request.nachName = nachName;
        request.vorName = vorName;
        request.geburtsDatum = geburtsDatum;
        request.beitrag = msg.value;
        request.empfaenger = empfaenger;
        request.idAntrag = 1;
        
        return idAntrag;
        
        // antragList.push(msg.sender);
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function payAmount() public restricted{
        request.empfaenger.transfer(request.beitrag);
    }
    

}
