pragma solidity >=0.4.22 <0.7.0;

contract InsuranceContract {

    struct PolicyHolder {
        address policyHolderAddress;
    }
    
    struct Beneficiary {
        uint idRequest;
        uint amount;
        address beneficiaryAddress;
    }

    address public manager;
    Beneficiary public beneficiary;
    PolicyHolder policyHolder;
    uint requestID;
    Beneficiary[] beneficiaryList;

    mapping(address => PolicyHolder) public policyHolders;
    
    mapping(address => Beneficiary[]) public beneficiaries;
    
    address [] public senderList;

    constructor() public {
       manager = msg.sender;
    }
    
    function addRequest(
        address  addressBeneficiary
        ) 
        public payable 
        returns (uint idRequest)
        {
        
        require(msg.value > .01 ether);
        policyHolders[ msg.sender ].policyHolderAddress = msg.sender;
        
        beneficiary.amount = msg.value;
        beneficiary.beneficiaryAddress = addressBeneficiary;
        requestID = requestID + 1;
        beneficiary.idRequest = requestID;
        beneficiaries[ msg.sender ].push(beneficiary);
        
        
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

    function payAmountProcess(address policyHolderAddr) public restricted{
        beneficiaryList = beneficiaries[policyHolderAddr];
        uint arrayLength = beneficiaryList.length;
        for (uint i=0; i<arrayLength; i++) {
            beneficiaryList[i].beneficiaryAddress.transfer(beneficiaryList[i].amount);
        }
        delete beneficiaries[policyHolderAddr];
        delete policyHolders[policyHolderAddr];
    }
}
