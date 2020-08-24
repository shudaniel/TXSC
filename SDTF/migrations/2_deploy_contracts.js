// var Callback = artifacts.require("./callbacks.sol");
// module.exports = function (deployer) {
//     deployer.deploy(Callback);
// }

var Puzzle = artifacts.require("./test.sol");
module.exports = function (deployer) {
    deployer.deploy(Puzzle, [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]);
};