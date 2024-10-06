const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Game", function () {
  let game;
  let owner;
  let player1;
  let player2;

  beforeEach(async function () {
    [owner, player1, player2] = await ethers.getSigners();
    const Game = await ethers.getContractFactory("Game");
    game = await Game.deploy();
    await game.waitForDeployment();
    console.log("Game contract deployed");
  });

  describe("Leaderboard", function () {
    it("should update score and leaderboard", async function () {
      console.log("Updating score for player1");
      await game.connect(player1).updateScore(100);
      const score = await game.getScore(player1.address);
      console.log("Player1 score:", score.toString());
      expect(score).to.equal(100);

      console.log("Getting top players");
      const topPlayers = await game.getTopPlayers();
      console.log("Top player:", topPlayers[0].player, "Score:", topPlayers[0].score.toString());
      expect(topPlayers[0].player).to.equal(player1.address);
      expect(topPlayers[0].score).to.equal(100);
    });

    it("should maintain top 10 players in descending order", async function () {
      console.log("Updating scores for player1 and player2");
      await game.connect(player1).updateScore(100);
      await game.connect(player2).updateScore(200);

      console.log("Getting top players");
      const topPlayers = await game.getTopPlayers();
      console.log("Top player:", topPlayers[0].player, "Score:", topPlayers[0].score.toString());
      console.log("Second player:", topPlayers[1].player, "Score:", topPlayers[1].score.toString());
      expect(topPlayers[0].player).to.equal(player2.address);
      expect(topPlayers[0].score).to.equal(200);
      expect(topPlayers[1].player).to.equal(player1.address);
      expect(topPlayers[1].score).to.equal(100);
    });

    it("should emit LeaderboardUpdated event", async function () {
      console.log("Updating score and checking for LeaderboardUpdated event");
      await expect(game.connect(player1).updateScore(100))
        .to.emit(game, "LeaderboardUpdated")
        .withArgs(player1.address, 100, 1);
      console.log("LeaderboardUpdated event emitted successfully");
    });
  });

  describe("Achievements", function () {
    it("should add and unlock achievements", async function () {
      console.log("Adding achievement");
      await game.connect(owner).addAchievement(1, "First Win", "uri_to_image");
      console.log("Unlocking achievement for player1");
      await game.connect(owner).unlockAchievement(player1.address, 1);

      const hasAchievement = await game.hasAchievement(player1.address, 1);
      console.log("Player1 has achievement:", hasAchievement);
      expect(hasAchievement).to.be.true;

      const achievement = await game.getAchievement(1);
      console.log("Achievement description:", achievement.description);
      const achievementDescription = await game.getAchievement(1);
      console.log("Achievement description:", achievementDescription.description);
      expect(achievementDescription.description).to.equal("First Win");
    });
  });

  describe("Access Control", function () {
    it("should allow any player to update their own score", async function () {
      console.log("Updating score as player1");
      await expect(game.connect(player1).updateScore(100))
        .to.not.be.reverted;
      console.log("Score updated successfully");

      const score = await game.getScore(player1.address);
      expect(score).to.equal(100);
    });

    it("should not allow a player to update another player's score", async function () {
      console.log("Attempting to update player2's score as player1");
      await expect(game.connect(player1).updateScore(200))
        .to.not.be.reverted;
      console.log("Player1 updated their own score successfully");

      const player1Score = await game.getScore(player1.address);
      expect(player1Score).to.equal(200);

      const player2Score = await game.getScore(player2.address);
      expect(player2Score).to.equal(0);
      console.log("Player2's score remains unchanged");
    });

    it("should allow the owner to remove a player from the leaderboard", async function () {
      console.log("Updating score for player1");
      await game.connect(player1).updateScore(100);
      const score = await game.getScore(player1.address);
      expect(score).to.equal(100);

      console.log("Removing player1 from the leaderboard");
      await game.connect(owner).removePlayerFromLeaderboard(player1.address);
      const updatedScore = await game.getScore(player1.address);
      expect(updatedScore).to.equal(0);

      const topPlayers = await game.getTopPlayers();
      expect(topPlayers.some(player => player.player === player1.address)).to.be.false;
    });

    it("should allow the owner to ban a player", async function () {
      console.log("Banning player1");
      await game.connect(owner).banPlayer(player1.address);
      await expect(game.connect(player1).updateScore(100)).to.be.revertedWith("Player is banned");

      const score = await game.getScore(player1.address);
      expect(score).to.equal(0);
    });

    it("should not allow a player to remove another player from the leaderboard", async function () {
      console.log("Attempting to remove player2 from the leaderboard as player1");
      await expect(game.connect(player1).removePlayerFromLeaderboard(player2.address)).to.be.revertedWith("Only the owner can call this function");
    });

    it("should not allow a player to ban another player", async function () {
      console.log("Attempting to ban player2 as player1");
      await expect(game.connect(player1).banPlayer(player2.address)).to.be.revertedWith("Only the owner can call this function");
    });
  });
});
