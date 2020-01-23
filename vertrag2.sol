pragma solidity >=0.4.22 <0.7.0;

contract Todesvertrag {

    struct Sender {
        string nachName;
        string vorName;
        uint geburtsDatum;
        uint todesDatum;
        address sender;
    }
    
    struct Empfaenger {
        uint idAntrag;
        uint beitrag;
        address empfaenger;
    }
    
    /*struct Antrag {
        string nachName;
        string vorName;
        uint idAntrag;
        uint geburtsDatum;
        uint todesDatum;
        uint beitrag;
        address empfaenger;
    }*/
    
    address public manager;
    Empfaenger public emp;
    Sender sender;
    uint antragID;

    mapping(address => Sender) public senders;
    
    mapping(address => Empfaenger[]) public empfaengers;
    
    address [] public senderList;
    
    // Antrag[] public antragList;
    
    constructor() public {
       manager = msg.sender;
    }

    
    
    function addAntrag(
        string vornameSender, 
        string nachnameSender, 
        // uint geburtsDatum, 
        // uint todesDatum,
        address addressEmpfaenger
        ) 
        public payable 
        returns (uint idAntrag)
        {
            
        
        
        require(msg.value > .01 ether);
        senders[ msg.sender].vorName = vornameSender;
        senders[ msg.sender].nachName = nachnameSender;
        senders[ msg.sender].sender = msg.sender;
        
        emp.beitrag = msg.value;
        emp.empfaenger = addressEmpfaenger;

        antragID = antragID + 1;
        emp.idAntrag = antragID;
        empfaengers[ msg.sender ].push(emp);
        
        
        bool istGefunden = false;
        for (uint i=0; i<senderList.length; i++) { 
            if (senderList[i] == msg.sender) {
                istGefunden = true;
            }
        }
        if (!istGefunden) {
            senderList.push(msg.sender);
        }
        
        return antragID;
        
        // antragList.push(msg.sender);
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    /*function getEmpfaenger(address sender) public view returns (address[]) {
        return empfaengers [sender];
    }*/
    
    function payAmount(address sender) public restricted{
        Empfaenger[] listEmp = empfaengers[sender];
        uint arrayLength = listEmp.length;
        for (uint i=0; i<arrayLength; i++) {
            listEmp[i].empfaenger.transfer(listEmp[i].beitrag);
        }
        delete empfaengers[sender];
        delete senders[sender];

    }
}
