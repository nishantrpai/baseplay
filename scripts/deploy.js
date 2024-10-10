const hre = require("hardhat");

async function main() {
  console.log("Deploying Game contract...");

  // Deploy Game contract
  const Game = await hre.ethers.getContractFactory("Game");
  const game = await Game.deploy();
  await game.waitForDeployment();

  const gameAddress = await game.getAddress();
  console.log("Game deployed to:", gameAddress);

  console.log("Deployment complete!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
