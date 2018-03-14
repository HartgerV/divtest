var StakeAgent = artifacts.require("./StakeAgent.sol");

module.exports = function(deployer) {
  deployer.deploy(StakeAgent);
};
