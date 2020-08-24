const WolframAlpha = artifacts.require("WolframAlpha");

module.exports = function(deployer) {
  deployer.deploy(WolframAlpha);
};
