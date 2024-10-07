const hre = require("hardhat");
const { ethers } = require("ethers");

async function main() {
  console.log("Starting remote test for Game contract on Base Sepolia...");

  // Connect to the Base Sepolia network
  const provider = new ethers.JsonRpcProvider("https://base-sepolia.blockpi.network/v1/rpc/public");
  
  // Load the wallet using the private key from the .env file
  const privateKey = process.env.WALLET_KEY;
  if (!privateKey) {
    throw new Error("WALLET_KEY not found in .env file");
  }
  const wallet = new ethers.Wallet(privateKey, provider);

  // The address of the deployed Game contract
  const gameAddress = "0x3dcec8F10BAaD078A15707930c78b7fc4c3d7CD0";

  // Get the Game contract instance
  const Game = await hre.ethers.getContractFactory("Game");
  const game = Game.attach(gameAddress).connect(wallet);

  console.log("Connected to Game contract at:", gameAddress);

  // Perform some test operations
  try {
    // Get game name and description
    const gameName = await game.gameName();
    const gameDescription = await game.gameDescription();
    console.log("Game Name:", gameName);
    console.log("Game Description:", gameDescription);

    // Update score (this will cost gas)
    console.log("Updating score...");
    const tx = await game.updateScore(100);
    await tx.wait();
    console.log("Score updated successfully");

    // Get updated score
    const score = await game.getScore(wallet.address);
    console.log("Current Score:", score.toString());

    // Get top players
    const topPlayers = await game.getTopPlayers();
    console.log("Top Players:");
    topPlayers.forEach((player, index) => {
      console.log(`${index + 1}. Address: ${player.player}, Score: ${player.score.toString()}`);
    });

  } catch (error) {
    console.error("Error during remote test:", error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
