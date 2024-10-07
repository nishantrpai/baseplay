// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./AchievementManager.sol";
import "./LeaderboardManager.sol";

// A basic contract where we can store leaderboard and achievements on chain
// This contract will be used by GameFactory.sol for making a new contract for each game
contract Game {
    address public owner;
    string public gameName;
    string public gameDescription;
    mapping(address => uint256) public playerScores;
    mapping(address => bool) public bannedPlayers;
    uint256 public totalPlayers;

    AchievementManager public achievementManager;
    LeaderboardManager public leaderboardManager;

    event ScoreUpdated(address indexed player, uint256 score);
    event PlayerRemoved(address indexed player);
    event PlayerBanned(address indexed player);
    event NewPlayerAdded(address indexed player);

    constructor(address _owner, string memory _gameName, string memory _gameDescription) {
        require(bytes(_gameDescription).length <= 140, "Description must be 140 characters or less");
        owner = _owner;
        gameName = _gameName;
        gameDescription = _gameDescription;
        achievementManager = new AchievementManager();
        leaderboardManager = new LeaderboardManager();
    }

    // Modifier: Ensures only the owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Modifier: Ensures the player is not banned
    modifier notBanned() {
        require(!bannedPlayers[msg.sender], "Player is banned");
        _;
    }

    // Function: Updates the score of a player and potentially the leaderboard
    // Can be called by any player to update their own score
    function updateScore(uint256 score) public notBanned {
        if (playerScores[msg.sender] == 0) {
            totalPlayers++;
            emit NewPlayerAdded(msg.sender);
        }
        playerScores[msg.sender] = score;
        emit ScoreUpdated(msg.sender, score);
        leaderboardManager.updateLeaderboard(address(this), msg.sender, score);
    }

    // Function: Get the game description
    function getGameDescription() public view returns (string memory) {
        return gameDescription;
    }

    // Function: Get the game name
    function getGameName() public view returns (string memory) {
        return gameName;
    }

    // Function: Adds a new achievement to the game
    // Can only be called by the owner
    function addAchievement(uint256 achievementId, string memory description, string memory imageURI) public onlyOwner {
        achievementManager.addAchievement(achievementId, description, imageURI);
    }

    // Function: Unlocks an achievement for a player
    // Can only be called by the owner
    function unlockAchievement(address player, uint256 achievementId) public onlyOwner {
        achievementManager.unlockAchievement(player, achievementId);
    }

    // Function: Removes a player from the leaderboard and resets their score
    // Can only be called by the owner
    function removePlayerFromLeaderboard(address player) public onlyOwner {
        if (playerScores[player] > 0) {
            totalPlayers--;
        }
        playerScores[player] = 0;
        leaderboardManager.removePlayerFromLeaderboard(address(this), player);
        emit PlayerRemoved(player);
    }

    // Function: Bans a player from updating their score
    // Can only be called by the owner
    function banPlayer(address player) public onlyOwner {
        bannedPlayers[player] = true;
        emit PlayerBanned(player);
    }

    // Function: Retrieves the score of a player
    // This is a view function and doesn't modify the contract state
    function getScore(address player) public view returns (uint256) {
        return playerScores[player];
    }

    // Function: Retrieves the top 10 players
    // This is a view function and doesn't modify the contract state
    function getTopPlayers() public view returns (LeaderboardManager.LeaderboardEntry[10] memory) {
        return leaderboardManager.getTopPlayers(address(this));
    }

    // Function: Checks if a player has unlocked a specific achievement
    // This is a view function and doesn't modify the contract state
    function hasAchievement(address player, uint256 achievementId) public view returns (bool) {
        return achievementManager.hasAchievement(player, achievementId);
    }

    // Function: Gets the description and image URI of an achievement
    // This is a view function and doesn't modify the contract state
    function getAchievement(uint256 achievementId) public view returns (string memory description, string memory imageURI) {
        return achievementManager.getAchievement(achievementId);
    }

    // Function: Gets the total number of players
    // This is a view function and doesn't modify the contract state
    function getTotalPlayers() public view returns (uint256) {
        return totalPlayers;
    }

    // Function: Gets the number of players who have unlocked a specific achievement
    // This is a view function and doesn't modify the contract state
    function getAchievementUnlockCount(uint256 achievementId) public view returns (uint256) {
        return achievementManager.getAchievementUnlockCount(achievementId);
    }
}