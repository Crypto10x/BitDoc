const Token = artifacts.require("Token");
const MockWBTC =artifacts.require("MockWBTC");
const MockDai =artifacts.require("MockDai");
const DcaSwap = artifacts.require("DcaSwap");
// const TimeLockedWalletFactory = artifacts.require("TimeLockedWalletFactory");

module.exports = async function(deployer) {
  // Deploy Token
  await deployer.deploy(Token);
  const token = await Token.deployed();

  // Deploy DCA swap
  await deployer.deploy(DcaSwap, token.address);
  const dcaSwap = await DcaSwap.deployed();
  
  // Transfer all tokens to DCASwap (1M)
  await token.transfer(dcaSwap.address,'1000000000000000000000000');

  // deploy mock DAI
  await deployer.deploy(MockDai);
  const MockDai = await Token.deployed();

  // deploy mock BTC
  await deployer.deploy(MockWBTC);
  const MockWBTC = await MockWBTC.deployed();
};
