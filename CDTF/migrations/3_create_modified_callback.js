const BlockKingModified = artifacts.require("BlockKingModified");

module.exports = function(deployer) {
  deployer.deploy(BlockKingModified, 0);
};
