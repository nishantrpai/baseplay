// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// A basic contract where we can store leaderboard and achievements on chain
// This contract will be used by GameFactory.sol for making a new contract for each game
contract Game {
    address public owner;
    struct LeaderboardEntry {
        address player;
        uint256 score;
    }
    LeaderboardEntry[10] public topPlayers;
    mapping(address => uint256) public playerScores;
    mapping(address => bool) public bannedPlayers;

    struct Achievement {
        string description;
        string imageURI;
    }
    mapping(uint256 => Achievement) public achievements;
    mapping(address => mapping(uint256 => bool)) public playerAchievements;

    event ScoreUpdated(address player, uint256 score);
    event LeaderboardUpdated(address player, uint256 score, uint256 rank);
    event AchievementUnlocked(address player, uint256 achievementId);
    event AchievementAdded(uint256 achievementId, string description, string imageURI);
    event PlayerRemoved(address player);
    event PlayerBanned(address player);

    // Constructor: Sets the contract deployer as the owner
    constructor() {
        owner = msg.sender;
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
        playerScores[msg.sender] = score;
        emit ScoreUpdated(msg.sender, score);
        _updateLeaderboard(msg.sender, score);
    }

    // Internal function to update the leaderboard
    function _updateLeaderboard(address player, uint256 score) internal {
        uint256 i;
        for (i = 0; i < 10; i++) {
            if (score > topPlayers[i].score) {
                // Shift lower scores down
                for (uint256 j = 9; j > i; j--) {
                    topPlayers[j] = topPlayers[j-1];
                }
                // Insert new high score
                topPlayers[i] = LeaderboardEntry(player, score);
                emit LeaderboardUpdated(player, score, i + 1);
                break;
            }
        }
    }

    // Function: Adds a new achievement to the game
    // Can only be called by the owner
    function addAchievement(uint256 achievementId, string memory description, string memory imageURI) public onlyOwner {
        achievements[achievementId] = Achievement(description, imageURI);
        emit AchievementAdded(achievementId, description, imageURI);
    }

    // Function: Unlocks an achievement for a player
    // Can only be called by the owner
    function unlockAchievement(address player, uint256 achievementId) public onlyOwner {
        require(bytes(achievements[achievementId].description).length > 0, "Achievement does not exist");
        playerAchievements[player][achievementId] = true;
        emit AchievementUnlocked(player, achievementId);
    }

    // Function: Removes a player from the leaderboard and resets their score
    // Can only be called by the owner
    function removePlayerFromLeaderboard(address player) public onlyOwner {
        playerScores[player] = 0;
        for (uint256 i = 0; i < 10; i++) {
            if (topPlayers[i].player == player) {
                // Shift lower scores up
                for (uint256 j = i; j < 9; j++) {
                    topPlayers[j] = topPlayers[j+1];
                }
                topPlayers[9] = LeaderboardEntry(address(0), 0);
                break;
            }
        }
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
    function getTopPlayers() public view returns (LeaderboardEntry[10] memory) {
        return topPlayers;
    }

    // Function: Checks if a player has unlocked a specific achievement
    // This is a view function and doesn't modify the contract state
    function hasAchievement(address player, uint256 achievementId) public view returns (bool) {
        return playerAchievements[player][achievementId];
    }

    // Function: Gets the description and image URI of an achievement
    // This is a view function and doesn't modify the contract state
    function getAchievement(uint256 achievementId) public view returns (string memory description, string memory imageURI) {
        Achievement memory achievement = achievements[achievementId];
        return (achievement.description, achievement.imageURI);
    }
}