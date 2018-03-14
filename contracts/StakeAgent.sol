pragma solidity ^0.4.0;

import "./interfaces/CasperInterface.sol";
import "./StakePool.sol";

contract StakeAgent {
    CasperInterface casper;

    mapping(uint => StakePool) public deployedStakePools;
    uint public numPools;
    uint public logoutCursor;
    uint public withdrawCursor;    
    uint public endCursor;
    address public owner;
    uint public logoutDynasty;
    uint public withdrawDelay = 2;

    function StakeAgent(address casperAddress){
        owner = msg.sender;
        casper = CasperInterface(casperAddress);
    }

    modifier onlyBy(address _account)
    {
        require(msg.sender == _account);
        _;
    }

    event receivedStakeAgent(uint amount);

    function () payable public {
      receivedStakeAgent(msg.value);
    }

    function createPool() returns(address a){
        require(canCreatePool());
        StakePool stakePool = new StakePool(address(casper));
        deployedStakePools[numPools] = stakePool;
        stakePool.deposit.value(20 ether)();
        stakePool.stake(20 ether);
        numPools++;
        return stakePool;
    }

    function getBalance() constant public returns(uint256) {
        return address(this).balance;
    }
    
    function canCreatePool() constant public returns(bool) {
        return address(this).balance >= 20 ether;
    }

    function deposit() public payable {
        receivedStakeAgent(msg.value);
    }

    function withdraw(uint amount) public onlyBy(owner) {
        msg.sender.transfer(amount);
    }
    
    function end() public {
        require(canEnd());
        deployedStakePools[endCursor].end();
        endCursor++;
    }
    
    function withdrawStake() public {
        require(canWithdraw());
        deployedStakePools[withdrawCursor].withdrawStake();
        withdrawCursor++;
    }
    
    function logout() public {
        require(canLogout());
        deployedStakePools[logoutCursor].logout();
        logoutCursor++;
    }
    
    function canLogout() constant public returns (bool) {
        return deployedStakePools[logoutCursor].canLogout();
    }
    
    function canWithdraw() constant public returns (bool) {
        return deployedStakePools[withdrawCursor].canWithdraw();
    }
    
    function canEnd() constant public returns (bool) {
        return deployedStakePools[endCursor].canEnd();
    }


}
