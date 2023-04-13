// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

contract KYC{


    struct Customer {
        string userName;   
        string cxData;
        bool kycStatus;
        uint256 downVotes;
        uint256 upVotes;  
        address bank;
    }
    
    struct Bank {
        string bankName;
        address ethAddress;
        uint256 complaintsReported;
        uint256 KYC_count;
        bool isAllowedToVote;
        string regNumber;
    }
 
    struct KYC_Req{
        string userName;
        address bankAddress;
        string cxData;
    }
    mapping(string => Customer) customers;
    mapping(address => Bank) banks;
    mapping(string => KYC_Req) customerKycReq;

    address admin;
     constructor() {
         admin = msg.sender;
     }
    
    function addKycRequest(string memory _userName, string memory _customerData) public{
        require(customers[_userName].bank == address(0), "Customer is already present, please call modifyCustomer to edit the customer data");
      customerKycReq[_userName]= KYC_Req(_userName, msg.sender, _customerData);
      banks[msg.sender].KYC_count++;

    }
    
    function addCustomer(string memory _userName, string memory _customerData) public {
        require(customers[_userName].bank == address(0), "Customer is already present, please call modifyCustomer to edit the customer data");
        customers[_userName] = Customer(_userName, _customerData, false, 0, 0, msg.sender);
    }

    function removeKycRequest(string memory _userName) public{
        require(customerKycReq[_userName].bankAddress == msg.sender, "You are not authorised bank");
        delete customerKycReq[_userName];
    }
    function viewCustomer(string memory _userName) public view returns(string memory, string memory, bool, uint256, uint256, address){
         return (customers[_userName].userName, customers[_userName].cxData, customers[_userName].kycStatus, customers[_userName].downVotes, customers[_userName].upVotes, customers[_userName].bank);
         
     }

     function upVote(string memory _userName) public{
         require(banks[msg.sender].isAllowedToVote = true, " you are not authorised bank to upvote");
         customers[_userName].upVotes = customers[_userName].upVotes + 1;
         if(customers[_userName].downVotes < customers[_userName].upVotes){
             customers[_userName].kycStatus = true;
            }

     }
    function downVote(string memory _userName) public{
        require(banks[msg.sender].isAllowedToVote = true, " you are not authorised bank to downvote");
        customers[_userName].downVotes = customers[_userName].downVotes + 1;
        
    }

    function modifyCustomer(string memory _userName, string memory _newCustomerData) public{
        require(customers[_userName].bank != address(0), "Customer is not present in the database");
        delete customerKycReq[_userName];
        customers[_userName].cxData = _newCustomerData;
        customers[_userName].upVotes = 0;
        customers[_userName].downVotes = 0;
        
    }
     
     function bankComplaints(address _bankAddress) public view returns(uint256){
         return banks[_bankAddress].complaintsReported;
     }

     function viewBank(address _bankAddress) public view returns(string memory, address, uint256, uint256, bool, string memory){
         return (banks[_bankAddress].bankName, banks[_bankAddress].ethAddress, banks[_bankAddress].complaintsReported, banks[_bankAddress].KYC_count, banks[_bankAddress].isAllowedToVote, banks[_bankAddress].regNumber); 
     }

     function reportBank(address _bankAddress, string memory _bankName) public{
         banks[_bankAddress].complaintsReported++;

         //Suppose we have 6 banks in the network then 1/3 of bank will be 2
         if(banks[_bankAddress].complaintsReported > 2){
             banks[_bankAddress].isAllowedToVote = false;
         }
         
     }

     function addBank(string memory _bankName, address _bankAddress, string memory _regNumber) public{
         require(msg.sender == admin, " You are not admin");
        banks[_bankAddress] = Bank(_bankName, _bankAddress, 0, 0, true, _regNumber);
}

    function modifyBank(address _bankAddress, bool _isAllowedToVote) public {
        require(msg.sender == admin, " You are not admin");
        banks[_bankAddress].isAllowedToVote = _isAllowedToVote;
    }

    function removeBank(address _bankAddress) public {
        require(msg.sender == admin, " You are not admin");
        delete banks[_bankAddress];
    }
}