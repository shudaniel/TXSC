const BlockKing = artifacts.require("BlockKing");

module.exports = function(deployer) {
  deployer.deploy(BlockKing, 0);
};
