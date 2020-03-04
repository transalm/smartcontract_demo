pragma solidity >=0.4.22 <0.7.0;

contract InsuranceContract {
    
    struct PolicyContract {
        int dateOfBirth;
        address policyHolderAddress;
        address beneficiaryAddress;
        uint refund;
        uint policyID;
        uint premium;
    }

    address public insurer;
    uint requestID;
    PolicyContract pc;
    PolicyContract[] public policyContractList;

    constructor() public {
       insurer = msg.sender;
    }
    
    function underwrite (
        int dateOfBirthInsured, 
        address policyHoldersAddress,
        address beneficiaryAddress,
        uint premium
        ) 
        public payable restricted 
         returns (uint idRequest)
        {
            
        require(msg.value > .01 ether);

        pc.refund = msg.value;
        pc.dateOfBirth = dateOfBirthInsured;
        pc.beneficiaryAddress = beneficiaryAddress;
        pc.policyHolderAddress = policyHoldersAddress;
        pc.premium = premium;
        requestID = requestID + 1;
        pc.policyID = requestID;
        policyContractList.push(pc);
        
        return requestID;
    }
    
    modifier restricted() {
        require(msg.sender == insurer);
        _;
    }

    function getPolicyContract(uint policyID) public view returns (uint, address, address, int, uint){
        for (uint i=0; i<policyContractList.length; i++) { 
            if (policyContractList[i].policyID == policyID) {
                return (policyContractList[i].policyID , policyContractList[i].policyHolderAddress, policyContractList[i].beneficiaryAddress, policyContractList[i].dateOfBirth, policyContractList[i].refund );
            }
        }
        return (0, 0x0, 0x0, 0, 0);
    }

    function claim(uint policyID, int dateOfDeath) public restricted{
        
        for (uint i=0; i<policyContractList.length; i++) { 
            if (policyContractList[i].policyID == policyID) {
                
                int startDate = policyContractList[i].dateOfBirth; 
                int endDate = dateOfDeath; 

                int diff = (endDate - startDate) / 60 / 60 / 24 / 365; 
                
                if (diff < 50) {
                    policyContractList[i].beneficiaryAddress.transfer(policyContractList[i].refund);
                } else {
                    insurer.transfer(policyContractList[i].refund);
                }
                policyContractList[i].refund = 0;
            }
        }
    } 
}
