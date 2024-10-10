const hre = require("hardhat");
const { parseEther } = hre.ethers;

const depositEth = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const account = '0x5A8064F8249D079f02bfb688f4AA86B6b2C65359';
  const ethAmount = 1; // 1 ETH

  // Add signer account to chain
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [account],
  });

  const signer = await hre.ethers.getSigner(account);

  // Send 1 ETH to the signer account
  await deployer.sendTransaction({
    to: signer.address,
    value: parseEther(ethAmount.toString()),
    gasLimit: 2000000
  });

  console.log(`Added signer account ${account} to chain and deposited ${ethAmount} ETH`);

  // Stop impersonating the account
  await hre.network.provider.request({
    method: "hardhat_stopImpersonatingAccount",
    params: [account],
  });
};

depositEth();