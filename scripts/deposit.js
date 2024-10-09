const hre = require("hardhat");
const { parseEther } = hre.ethers;

const depositEth = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const account = '0x5A8064F8249D079f02bfb688f4AA86B6b2C65359';
  const ethAmount = 1; // 1 ETH

  const tx = await deployer.sendTransaction({
    to: account,
    value: parseEther(ethAmount.toString()),
    gasLimit: 2000000
  });

  console.log(`Deposited ${ethAmount} ETH to ${account}`);
};

depositEth();