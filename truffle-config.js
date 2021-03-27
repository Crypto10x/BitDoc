require('babel-register');
require('babel-polyfill');
const HDWalletProvider = require("@truffle/hdwallet-provider");
// const privKeys = `${process.env.PRIVATE_KEY}`
const privKeys ="9eaedfd222c230b2a7f41ad5cf52f7bd90d139f5437dc8377202666a1607f336";
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(privKeys, "https://rinkeby.infura.io/v3/990912b538c14416810afb6253ca4d5d")
      },
      network_id: 4,
      gas: 9000000,
      gasPrice: 10000000000,
    },
    // bsctestnet: {
    //   provider: () => new HDWalletProvider(privKeys, `https://data-seed-prebsc-1-s1.binance.org:8545`),
    //   network_id: 97,
    //   confirmations: 10,
    //   timeoutBlocks: 200,
    //   skipDryRun: true
    // },
    
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}
