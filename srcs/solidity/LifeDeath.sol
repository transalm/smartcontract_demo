pragma solidity >=0.4.22 <0.7.0;

contract InsuranceContract {

    struct Insured {
        string nameLast;
        string nameFirst;
        uint geburtsDatum;
        uint todesDatum;
        address sender;
    }
    
    struct Empfaenger {
        uint idAntrag;
        uint beitrag;
        address empfaenger;
    }
    
    address public manager;
    Empfaenger public emp;
    Insured sender;
    uint antragID;
    
    mapping(address => Insured) public senders;
    
    mapping(address => Empfaenger[]) public empfaengers;
    
    address [] public senderList;
    
    constructor() public {
       manager = msg.sender;
    }
    
    function addAntrag( string nameFirstInsured, string nameLastInsured, address addressEmpfaenger) public payable returns (uint idAntrag){
        require(msg.value > .01 ether);
        senders[ msg.sender].nameFirst = nameFirstInsured;
        senders[ msg.sender].nameLast = nameLastInsured;
        senders[ msg.sender].sender = msg.sender;
        
        emp.beitrag = msg.value;
        emp.empfaenger = addressEmpfaenger;

        antragID = antragID + 1;
        emp.idAntrag = antragID;
        empfaengers[ msg.sender ].push(emp);
        
        
        bool hasPolicy = false;
        for (uint i=0; i<senderList.length; i++) { 
            if (senderList[i] == msg.sender) {
            hasPolicy = true;
            }   
        }
        if (!hasPolicy) {
            senderList.push(msg.sender);
        }
        
        return antragID;
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
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
