const TestToken = artifacts.require("TestToken");
// const MockBTC =artifacts.require("MockBTC");
// const MockDai =artifacts.require("MockDai");
// const DcaSwap = artifacts.require("DcaSwap");
// const BTCExchange =artifacts.require("BTCExchange");
// const TimeLockedWalletFactory = artifacts.require("TimeLockedWalletFactory");
// const test_user="0xBa8d32FA750fb85F85f931e2b8D6262360E2fBF6"
module.exports = async function(deployer) {
  // 1 Deploy DCA Token
  await deployer.deploy(TestToken);
  const token = await TestToken.deployed();

  // 2. Deploy DCA swap
  // await deployer.deploy(DcaSwap, token.address);
  // const dcaSwap = await DcaSwap.deployed();
  
  // // 3. Transfer all tokens to DCASwap (1M)
  // await token.transfer(dcaSwap.address,'1000000000000000000000000');

  // // 4. deploy mock DAI (USD stable coin)
  // await deployer.deploy(MockDai);
  // const dai = await MockDai.deployed();

  //5. Mint and transfer DAI to test_account for testing
  //


  // //6.deploy mock BTC
  // await deployer.deploy(MockBTC);
  // const btc = await MockBTC.deployed();

  //7. mock BTC exchange, if we could connect to uniswap would be good
  // await deployer.deploy(BTCExchange, btc.address);
  // const btcEx = await BTCExchange.deployed();

  //8. Transfer all BTC to btcEx (1M)
  // await btc.transfer(btcEx.address,'1000000000000000000000000');

};
