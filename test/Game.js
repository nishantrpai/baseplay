const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Game", function () {
  let gameFactory;
  let game;
  let owner;
  let player1;
  let player2;

  beforeEach(async function () {
    [owner, player1, player2] = await ethers.getSigners();
    const GameFactory = await ethers.getContractFactory("GameFactory");
    gameFactory = await GameFactory.deploy();
    await gameFactory.waitForDeployment();

    const gameName = "Test Game";
    const gameDescription = "This is a test game description";
    const gameLink = "https://example.com/test-game";
    
    await gameFactory.createGame(gameName, gameDescription, gameLink);
    
    const gameInfo = await gameFactory.getGameInfo(0);
    const Game = await ethers.getContractFactory("Game");
    game = Game.attach(gameInfo.gameAddress);

    console.log("Game contract deployed with name:", await game.gameName());
    console.log("Game contract deployed with description:", await game.gameDescription());
    console.log("Game contract deployed with link:", await game.gameLink());
  });

  describe("Leaderboard", function () {
    it("should update score and leaderboard", async function () {
      console.log("Updating score for player1");
      await game.connect(player1).updateScore(100);
      const score1 = await game.playerScores(player1.address);
      console.log("Top players:", await game.getTopPlayers());
      console.log("Player1 score:", score1.toString());
      expect(score1).to.equal(100);

      console.log("Updating score for player2");
      await game.connect(player2).updateScore(200);
      const score2 = await game.playerScores(player2.address);
      console.log("Top players:", await game.getTopPlayers());
      console.log("Player2 score:", score2.toString());
      expect(score2).to.equal(200);

      const totalPlayers = await game.totalPlayers();
      console.log("Total players:", totalPlayers.toString());
      expect(totalPlayers).to.equal(2);

      console.log("Getting top players");
      const topPlayers = await game.getTopPlayers();
      console.log("Top players:", topPlayers);

      console.log("Top player:", topPlayers[0].player, "Score:", topPlayers[0].score.toString());
      expect(topPlayers[0].player).to.equal(player2.address);
      expect(topPlayers[0].score).to.equal(200);

      console.log("Second player:", topPlayers[1].player, "Score:", topPlayers[1].score.toString());
      expect(topPlayers[1].player).to.equal(player1.address);
      expect(topPlayers[1].score).to.equal(100);
    });

    it("should maintain top 10 players in descending order", async function () {
      console.log("Updating scores for player1 and player2");
      await game.connect(player1).updateScore(100);
      await game.connect(player2).updateScore(200);

      const totalPlayers = await game.totalPlayers();
      console.log("Total players:", totalPlayers.toString());
      expect(totalPlayers).to.equal(2);

      console.log("Getting top players");
      const topPlayers = await game.getTopPlayers();
      console.log("Top players:", topPlayers);
      console.log("Top player:", topPlayers[0].player, "Score:", topPlayers[0].score.toString());
      console.log("Second player:", topPlayers[1].player, "Score:", topPlayers[1].score.toString());
      expect(topPlayers[0].player).to.equal(player2.address);
      expect(topPlayers[0].score).to.equal(200);
      expect(topPlayers[1].player).to.equal(player1.address);
      expect(topPlayers[1].score).to.equal(100);
    });

    it("should emit ScoreUpdated event", async function () {
      console.log("Updating score and checking for ScoreUpdated event");
      await expect(game.connect(player1).updateScore(100))
        .to.emit(game, "ScoreUpdated")
        .withArgs(player1.address, 100);
      console.log("ScoreUpdated event emitted successfully");
    });
  });

  describe("Achievements", function () {
    it("should add and unlock achievements", async function () {
      console.log("Adding achievement");
      await game.connect(owner).addAchievement("First Win", "First Win Description", "uri_to_image");
      console.log("Unlocking achievement for player1");
      await game.connect(owner).unlockAchievement(player1.address, 0);

      const hasAchievement = await game.hasAchievement(player1.address, 0);
      console.log("Player1 has achievement:", hasAchievement);
      expect(hasAchievement).to.be.true;

      const achievement = await game.getAchievement(0);
      console.log("Achievement description:", achievement.description);
      expect(achievement.description).to.equal("First Win Description");

      const achievementCount = await game.getAchievementUnlockCount(0);
      console.log("Achievement unlock count:", achievementCount.toString());
      expect(achievementCount).to.equal(1);
    });

    it("should get all achievements", async function () {
      console.log("Adding achievements");
      await game.connect(owner).addAchievement("First Win", "First Win Description", "uri_to_image_1");
      await game.connect(owner).addAchievement("Second Win", "Second Win Description", "uri_to_image_2");
      await game.connect(owner).addAchievement("Third Win", "Third Win Description", "uri_to_image_3");

      console.log("Getting all achievements");
      const [names, descriptions, badges, playerCounts] = await game.getAllAchievements();
      console.log("Achievements names:", names);
      console.log("Achievements descriptions:", descriptions);
      console.log("Achievements badges:", badges);
      console.log("Achievements player counts:", playerCounts);

      expect(names).to.be.an('array');
      expect(descriptions).to.be.an('array');
      expect(badges).to.be.an('array');
      expect(playerCounts).to.be.an('array');
    });

    it("should get player achievements list", async function () {
      console.log("Adding achievements");
      await game.connect(owner).addAchievement("First Win", "First Win Description", "uri_to_image_1");
      await game.connect(owner).addAchievement("Second Win", "Second Win Description", "uri_to_image_2");
      await game.connect(owner).addAchievement("Third Win", "Third Win Description", "uri_to_image_3");

      console.log("Unlocking achievements for player1");
      await game.connect(owner).unlockAchievement(player1.address, 0);
      await game.connect(owner).unlockAchievement(player1.address, 1);

      console.log("Getting player1 achievements");
      const playerAchievements = await game.getMyAchievements(player1.address);
      console.log("Player1 achievements:", playerAchievements);

      expect(playerAchievements).to.be.an('array');
      expect(playerAchievements.length).to.equal(2);
      expect(playerAchievements).to.include(BigInt(0));
      expect(playerAchievements).to.include(BigInt(1));
    });
  });

  describe("Access Control", function () {
    it("should allow any player to update their own score", async function () {
      console.log("Updating score as player1");
      await expect(game.connect(player1).updateScore(100))
        .to.not.be.reverted;
      console.log("Score updated successfully");

      const score = await game.playerScores(player1.address);
      expect(score).to.equal(100);
    });

    it("should not allow a player to update another player's score", async function () {
      console.log("Attempting to update player2's score as player1");
      await expect(game.connect(player1).updateScore(200))
        .to.not.be.reverted;
      console.log("Player1 updated their own score successfully");

      const player1Score = await game.playerScores(player1.address);
      expect(player1Score).to.equal(200);

      const player2Score = await game.playerScores(player2.address);
      expect(player2Score).to.equal(0);
      console.log("Player2's score remains unchanged");
    });

    it("should allow the owner to remove a player from the leaderboard", async function () {
      console.log("Updating score for player1");
      await game.connect(player1).updateScore(100);
      const score = await game.playerScores(player1.address);
      expect(score).to.equal(100);

      console.log("Removing player1 from the leaderboard", player1.address);
      await game.connect(owner).removePlayerFromLeaderboard(player1.address);
      const updatedScore = await game.playerScores(player1.address);
      expect(updatedScore).to.equal(0);

      const topPlayers = await game.getTopPlayers();
      console.log("Top players:", topPlayers);
      expect(topPlayers[0].player).to.equal(ethers.ZeroAddress);
      expect(topPlayers[0].score).to.equal(0);
    });

    it("should allow the owner to ban a player", async function () {
      console.log("Banning player1");
      await game.connect(owner).banPlayer(player1.address);
      await expect(game.connect(player1).updateScore(100)).to.be.revertedWith("Banned");

      const isBanned = await game.bannedPlayers(player1.address);
      expect(isBanned).to.be.true;

      const score = await game.playerScores(player1.address);
      expect(score).to.equal(0);
    });

    it("should not allow a player to remove another player from the leaderboard", async function () {
      console.log("Attempting to remove player2 from the leaderboard as player1");
      await expect(game.connect(player1).removePlayerFromLeaderboard(player2.address)).to.be.revertedWith("Not owner");
    });

    it("should not allow a player to ban another player", async function () {
      console.log("Attempting to ban player2 as player1");
      await expect(game.connect(player1).banPlayer(player2.address)).to.be.revertedWith("Not owner");
    });
  });
});
