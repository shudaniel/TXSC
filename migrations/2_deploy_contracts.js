var Puzzle = artifacts.require("./puzzle.sol");
module.exports = function (deployer) {
    deployer.deploy(Puzzle, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]);
};