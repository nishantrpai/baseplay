// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./AchievementManager.sol";
import "./LeaderboardManager.sol";

contract Game {
    address public immutable owner;
    string public gameName;
    string public gameDescription;
    string public gameLink;
    mapping(address => uint256) public playerScores;
    mapping(address => bool) public bannedPlayers;
    uint256 public totalPlayers;
    uint256 public nextAchievementId;

    AchievementManager public immutable achievementManager;
    LeaderboardManager public immutable leaderboardManager;

    event ScoreUpdated(address indexed player, uint256 score);
    event PlayerRemoved(address indexed player);
    event PlayerBanned(address indexed player);
    event NewPlayerAdded(address indexed player);
    event PlayerUnbanned(address indexed player);
    event AchievementAdded(uint256 indexed achievementId, string name, string description, string imageURI);

    constructor(address _owner, string memory _gameName, string memory _gameDescription, string memory _gameLink) {
        require(bytes(_gameDescription).length <= 140, "Description too long");
        owner = _owner;
        gameName = _gameName;
        gameDescription = _gameDescription;
        gameLink = _gameLink;
        achievementManager = new AchievementManager();
        leaderboardManager = new LeaderboardManager();
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notBanned() {
        require(!bannedPlayers[msg.sender], "Banned");
        _;
    }

    function updateScore(uint256 score) external notBanned {
        if (playerScores[msg.sender] == 0) {
            unchecked { ++totalPlayers; }
            emit NewPlayerAdded(msg.sender);
        }
        playerScores[msg.sender] = score;
        emit ScoreUpdated(msg.sender, score);
        leaderboardManager.updateLeaderboard(address(this), msg.sender, score);
    }

    function addAchievement(string calldata name, string calldata description, string calldata imageURI) external onlyOwner {
        require(bytes(name).length > 0, "Name cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");
        require(bytes(imageURI).length > 0, "Image URI cannot be empty");
        if (playerScores[msg.sender] == 0) {
            unchecked { ++totalPlayers; }
            emit NewPlayerAdded(msg.sender);
        }
        achievementManager.addAchievement(nextAchievementId, name, description, imageURI);
        emit AchievementAdded(nextAchievementId, name, description, imageURI);
        unchecked { ++nextAchievementId; }
    }

    function unlockAchievement(address player, uint256 achievementId) external onlyOwner {
        achievementManager.unlockAchievement(player, achievementId);
    }

    function removePlayerFromLeaderboard(address player) public onlyOwner {
        if (playerScores[player] > 0) {
            unchecked { --totalPlayers; }
        }
        playerScores[player] = 0;
        leaderboardManager.removePlayerFromLeaderboard(address(this), player);
        emit PlayerRemoved(player);
    }

    function banPlayer(address player) external onlyOwner {
        bannedPlayers[player] = true;
        removePlayerFromLeaderboard(player);
        emit PlayerBanned(player);
    }

    function removeFromBannedList(address player) external onlyOwner {
        bannedPlayers[player] = false;
        emit PlayerUnbanned(player);
    }

    function getTopPlayers() external view returns (LeaderboardManager.LeaderboardEntry[10] memory) {
        return leaderboardManager.getTopPlayers(address(this));
    }

    function hasAchievement(address player, uint256 achievementId) external view returns (bool) {
        return achievementManager.hasAchievement(player, achievementId);
    }

    function getAchievement(uint256 achievementId) external view returns (string memory name, string memory description, string memory imageURI) {
        return achievementManager.getAchievement(achievementId);
    }

    function getAchievementUnlockCount(uint256 achievementId) external view returns (uint256) {
        return achievementManager.getAchievementUnlockCount(achievementId);
    }

    function getAllAchievements() external view returns (string[] memory names, string[] memory descriptions, string[] memory badges, uint256[] memory playerCounts) {
        uint256 totalAchievements = achievementManager.getTotalAchievements();
        names = new string[](totalAchievements);
        descriptions = new string[](totalAchievements);
        badges = new string[](totalAchievements);
        playerCounts = new uint256[](totalAchievements);

        for (uint256 i = 0; i < totalAchievements;) {
            (names[i], descriptions[i], badges[i]) = achievementManager.getAchievement(i);
            playerCounts[i] = achievementManager.getAchievementUnlockCount(i);
            unchecked { ++i; }
        }
    }

    function getMyAchievements(address player) external view returns (uint256[] memory) {
        return achievementManager.getAchievementsOfPlayer(player);
    }

    function getGameDetails() external view returns (address, string memory, string memory, string memory, uint256) {
        return (owner, gameName, gameDescription, gameLink, totalPlayers);
    }
}