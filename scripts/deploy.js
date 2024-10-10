const hre = require("hardhat");

async function main() {
  console.log("Deploying GameFactory contract...");

  // Deploy GameFactory contract
  const GameFactory = await hre.ethers.getContractFactory("GameFactory");
  const gameFactory = await GameFactory.deploy();
  await gameFactory.waitForDeployment();

  const gameFactoryAddress = await gameFactory.getAddress();
  console.log("GameFactory deployed to:", gameFactoryAddress);

  console.log("Deployment complete!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
