const hre = require("hardhat");

async function main() {
  console.log("Deploying contracts...");

  // Get the deployer's address
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy GameFactory
  const GameFactory = await hre.ethers.getContractFactory("GameFactory");
  const gameFactory = await GameFactory.deploy();
  await gameFactory.waitForDeployment();

  console.log("GameFactory deployed to:", await gameFactory.getAddress());

  // Deploy a test Game using GameFactory
  const gameName = "Test Game";
  const gameDescription = "This is a test game deployed during the deployment script.";
  const gameLink = "https://example.com/test-game"; // Added game link

  const createGameTx = await gameFactory.createGame(gameName, gameDescription, gameLink); // Pass the game link
  const receipt = await createGameTx.wait();

  // Get the GameCreated event from the transaction receipt
  const gameCreatedEvent = receipt.logs.find(log => log.fragment.name === "GameCreated");
  const gameAddress = gameCreatedEvent.args.gameAddress;

  console.log("Sample Game deployed to:", gameAddress);

  // Interact with the deployed Game contract
  const Game = await hre.ethers.getContractFactory("Game");
  const game = Game.attach(gameAddress);

  // Add an achievement to the game
  const achievementId = 0;
  const achievementName = "First Achievement";
  const achievementDescription = "First Achievement Description";
  const achievementImageURI = "https://cdn-icons-png.flaticon.com/512/2583/2583264.png";
  await game.addAchievement(achievementName, achievementDescription, achievementImageURI);

  console.log("Added achievement to the game");

  // Update a player's score
  const [player] = await hre.ethers.getSigners();
  const score = 100;
  await game.connect(player).updateScore(score);

  console.log("Updated player's score");

  // Get top players
  const topPlayers = await game.getTopPlayers();
  console.log("Top players:", topPlayers);

  console.log("Deployment and interactions complete!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
