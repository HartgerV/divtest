var StakeAgent = artifacts.require("./StakeAgent.sol");
var Casper = artifacts.require("./Casper.sol");

contract('StakeAgent', (accounts) => {
    console.log("yolo");
   it("should receive ether", () => {
       StakeAgent.new()
           .then(async inst => {
               await web3.eth.sendTransaction({from:accounts[0], to:inst.address, value: web3.toWei(40, "ether")});
               var balance = await inst.getBalance();
               console.log(balance);
               assert.equal(balance, web3.toWei(40, "ether"), "ether was not received");
           });
   });
   it("creates stakepools", () => {
      StakeAgent.new()
          .then(async inst => {
              inst.createPool();
              assert.equal(inst.numPools().valueOf(), 1, "pool did not get created");
          }) ;
   });

});