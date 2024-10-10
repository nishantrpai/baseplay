require('@nomicfoundation/hardhat-toolbox');
require('dotenv').config();

const config = {
  solidity: {
    version: '0.8.24',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
      evmVersion: "paris"
    }
  },
  networks: {
    // for mainnet
    'base-mainnet': {
      url: 'https://mainnet.base.org',
      accounts: [process.env.WALLET_KEY],
      gasPrice: 1000000000,
    },
    // for testnet
    'base-sepolia': {
      url: 'https://sepolia.base.org',
      accounts: [process.env.WALLET_KEY],
      gasPrice: 1000000000,
      blockGasLimit: 0x1fffffffffffff,
      throwOnTransactionFailures: true,
      throwOnCallFailures: true,
      allowUnlimitedContractSize: true,
      timeout: 1800000
    },
    // for local dev environment
    'base-local': {
      url: 'http://localhost:8545',
      accounts: [process.env.WALLET_KEY],
      gasPrice: 1000000000,
    },
    // for hardhat network
    'hardhat': {
      chainId: 31337,
      gas: 30000000, // Set gas limit to match block gas limit
      allowUnlimitedContractSize: true, // Allow unlimited contract sizes
      mining: {
        auto: true,
        interval: 0
      }
    },
    // for local hardhat node
    'localhost': {
      url: 'http://127.0.0.1:8545',
      chainId: 31337,
      accounts: {
        mnemonic: "test test test test test test test test test test test junk",
        path: "m/44'/60'/0'/0",
        initialIndex: 0,
        count: 20,
        passphrase: "",
      },
    },
  },
  defaultNetwork: 'hardhat',
  etherscan: {
    apiKey: {
     "base-sepolia": 'PLACEHOLDER_STRING'
    },
    customChains: [
      {
        network: "base-sepolia",
        chainId: 84532,
        urls: {
         apiURL: "https://base-sepolia.blockscout.com/api",
         browserURL: "https://base-sepolia.blockscout.com"
        }
      }
    ]
  },
  sourcify: {
    enabled: false,
  }
};

module.exports = config;