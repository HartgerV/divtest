const StakeAgent = artifacts.require("./StakeAgent.sol");
const Casper = artifacts.require("./Casper.sol");

contract('StakeAgent', (accounts) => {
  let casperAddress = 0x62996F04E2F4B067A79Ec48C759D25312868B729;
  let inst;
  let inc = 1; //increment on accounts to ensure balance
  before((done) => {
    Casper.new()
      .then(async instance => {
        casperAddress = instance.address;
        console.log(casperAddress);
        done();
      })
  });
  beforeEach((done) => {
    StakeAgent.new(casperAddress,{from : accounts[0], gas : '2500000'})
      .then(async instance => {
        inst = instance;
        await web3.eth.sendTransaction({from: accounts[inc++], to: inst.address, value: web3.toWei(40, "ether")});
        done();
      });
  });
  it("should receive ether", async () => {
    let balance = await inst.getBalance();
    let amount =  web3.toWei(40, "ether");
    await web3.eth.sendTransaction({from: accounts[0], to: inst.address, value: amount});
    let newBalance = await inst.getBalance();
    assert.equal(newBalance.valueOf(), balance.plus(amount).valueOf(), "ether was not received");
  });
  it("creates stakepools", async () => {
    console.log(await inst.canCreatePool())
    await inst.createPool();
    assert.equal(inst.numPools().valueOf(), 1, "pool did not get created");
  });

});