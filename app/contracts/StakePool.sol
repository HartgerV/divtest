pragma solidity ^0.4.0;

import "./interfaces/CasperInterface.sol";

contract StakePool {
    CasperInterface public casper;
    address public owner;
    bool public active;
    bool public withdrawn;
    uint public logoutDynasty;
    uint public withdrawDelay = 2;
    uint public startDynasty;
    uint public stakeTime = 6; //18550 dynasties is ~1 year, if 1 block = 17s and 1 dynasty = 100 blocks

    function StakePool(address casperAddress){
        owner = msg.sender; 
        casper = CasperInterface(casperAddress);
        startDynasty = casper.get_dynasty();
        withdrawn = false;
    }
    
    modifier onlyBy(address _account)
    {
        require(msg.sender == _account);
        _;
    }
    
    modifier isActive() {
        require(active);
        _;
    }

    event received(uint amount);

    function () payable public {
      received(msg.value);
    }
    
    function getBalance() constant public returns(uint256) {
        return address(this).balance;
    }

    function deposit() public payable {
        received(msg.value);
    }
    
    function withdraw(uint amount) public onlyBy(owner) {
        msg.sender.transfer(amount);
    }

    function end() public onlyBy(owner) {
        require(canEnd());
        selfdestruct(owner);
    }
    
    function stake(uint amount) public {
        require(amount <= address(this).balance);
        casper.deposit.value(amount)(address(this), address(this));
        active = true;
    }
    
    function withdrawStake() public {
        require(canWithdraw());
        uint index = casper.get_validator_indexes(address(this));
        casper.withdraw(index);
        withdrawn = true;
    }
    
    function logout() public isActive {
        require(canLogout());
        casper.logout("Bye");
        logoutDynasty = casper.get_dynasty();
        active = false;
    }
    
    function canLogout() constant public returns (bool) {
        return (casper.get_dynasty() >= startDynasty + stakeTime);
    }
    
    function canWithdraw() constant public returns (bool) {
        return (casper.get_dynasty() >= logoutDynasty + withdrawDelay);
    }
    
    function canEnd() constant public returns (bool) {
        return (withdrawn);
    }

}
