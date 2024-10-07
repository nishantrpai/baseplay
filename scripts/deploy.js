const hre = require("hardhat");

async function main() {
  console.log("Deploying contracts...");

  // Deploy GameFactory
  const GameFactory = await hre.ethers.getContractFactory("GameFactory");
  const gameFactory = await GameFactory.deploy();
  await gameFactory.waitForDeployment();

  console.log("GameFactory deployed to:", await gameFactory.getAddress());

  // Deploy a test Game using GameFactory
  const gameName = "Test Game";
  const gameDescription = "This is a test game deployed during the deployment script.";

  const createGameTx = await gameFactory.createGame(gameName, gameDescription);
  const receipt = await createGameTx.wait();

  // Get the GameCreated event from the transaction receipt
  const gameCreatedEvent = receipt.logs.find(log => log.fragment.name === "GameCreated");
  const gameAddress = gameCreatedEvent.args.gameAddress;

  console.log("Sample Game deployed to:", gameAddress);
  console.log("Deployment complete!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
