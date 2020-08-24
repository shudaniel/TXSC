// var Callback = artifacts.require("./callbacks.sol");
// module.exports = function (deployer) {
//     deployer.deploy(Callback);
// }

var Puzzle = artifacts.require("./puzzle.sol");
module.exports = function (deployer) {
    deployer.deploy(Puzzle, [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]);
};