pragma solidity >=0.4.22 <0.7.0;

contract InsuranceContract {
    
    struct LifeContract {
        int dateOfBirth;
        address policyHolderAddress;
        address beneficiaryAddress;
        uint refund;
        uint policyID;
        uint premium;
    }

    address public insurer;
    uint requestID;
    LifeContract pc;
    LifeContract[] public contractCollections;

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
        pc.policyID = ++requestID;
        policies[pc.policyID].push(pc);
        return pc.policyID;
    }
    
    modifier restricted() {
        require(msg.sender == insurer);
        _;
    }

    function getPolicyContract(uint policyID) public view returns (uint, address, address, int, uint){
        for (uint i=0; i<lifeContractCollection.length; i++) { 
            if (lifeContractCollection[i].policyID == policyID) {
                return (lifeContractCollection[i].policyID , lifeContractCollection[i].policyHolderAddress, lifeContractCollection[i].beneficiaryAddress, lifeContractCollection[i].dateOfBirth, lifeContractCollection[i].refund );
            }
        }
        return (0, 0x0, 0x0, 0, 0);
    }

    function claim(uint policyID, int dateOfDeath) public restricted{
        
        for (uint i=0; i<contractCollections.length; i++) { 
            if (contractCollections[i].policyID == policyID) {
                
                int startDate = contractCollections[i].dateOfBirth; 
                int endDate = dateOfDeath; 

                int diff = (endDate - startDate) / 60 / 60 / 24 / 365; 
                
                if (diff < 50) {
                    contractCollections[i].beneficiaryAddress.transfer(contractCollections[i].refund);
                } else {
                    insurer.transfer(contractCollections[i].refund);
                }
                contractCollections[i].refund = 0;
            }
        }
    } 
}
//eof vim:syntax=cpp:ts=4:expandtab
