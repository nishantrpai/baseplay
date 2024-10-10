// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./AchievementBadge.sol";

/// @title AchievementManager
/// @notice Manages achievements and their associated badges for players
contract AchievementManager {
    /// @dev Struct to store achievement details
    struct Achievement {
        string name;
        string description;
        string imageURI;
        AchievementBadge badge;
        uint256 unlockCount;
    }

    /// @dev Mapping of achievement IDs to Achievement structs
    mapping(uint256 => Achievement) public achievements;
    /// @dev Mapping of player addresses to their unlocked achievements
    mapping(address => mapping(uint256 => bool)) public playerAchievements;
    /// @dev Counter to keep track of the total number of achievements
    uint256 public totalAchievements;

    /// @dev Event emitted when a player unlocks an achievement
    event AchievementUnlocked(address indexed player, uint256 indexed achievementId);
    /// @dev Event emitted when a new achievement is added
    event AchievementAdded(uint256 indexed achievementId, string name, string description, string imageURI);

    /// @notice Adds a new achievement to the system
    /// @param achievementId Unique identifier for the achievement
    /// @param name Name of the achievement
    /// @param description Text description of the achievement
    /// @param imageURI URI of the image associated with the achievement
    function addAchievement(uint256 achievementId, string calldata name, string calldata description, string calldata imageURI) external {
        AchievementBadge newBadge = new AchievementBadge(description, imageURI);
        achievements[achievementId] = Achievement(name, description, imageURI, newBadge, 0);
        unchecked { ++totalAchievements; }
        emit AchievementAdded(achievementId, name, description, imageURI);
    }

    /// @notice Unlocks an achievement for a player
    /// @param player Address of the player unlocking the achievement
    /// @param achievementId ID of the achievement being unlocked
    function unlockAchievement(address player, uint256 achievementId) external {
        require(bytes(achievements[achievementId].description).length > 0, "Achievement does not exist");
        require(!playerAchievements[player][achievementId], "Achievement already unlocked");
        
        playerAchievements[player][achievementId] = true;
        achievements[achievementId].badge.mint(player);
        unchecked { ++achievements[achievementId].unlockCount; }
        emit AchievementUnlocked(player, achievementId);
    }

    /// @notice Checks if a player has unlocked a specific achievement
    /// @param player Address of the player to check
    /// @param achievementId ID of the achievement to check
    /// @return bool indicating whether the player has unlocked the achievement
    function hasAchievement(address player, uint256 achievementId) external view returns (bool) {
        return playerAchievements[player][achievementId];
    }

    /// @notice Retrieves the details of a specific achievement
    /// @param achievementId ID of the achievement to retrieve
    /// @return name Name of the achievement
    /// @return description Text description of the achievement
    /// @return imageURI URI of the image associated with the achievement
    function getAchievement(uint256 achievementId) external view returns (string memory name, string memory description, string memory imageURI) {
        Achievement storage achievement = achievements[achievementId];
        return (achievement.name, achievement.description, achievement.imageURI);
    }

    /// @notice Gets the number of players who have unlocked a specific achievement
    /// @param achievementId ID of the achievement to check
    /// @return uint256 The number of players who have unlocked the achievement
    function getAchievementUnlockCount(uint256 achievementId) external view returns (uint256) {
        return achievements[achievementId].unlockCount;
    }

    /// @notice Gets the total number of achievements
    /// @return uint256 The total number of achievements
    function getTotalAchievements() external view returns (uint256) {
        return totalAchievements;
    }

    /// @notice Gets the achievements of a specific player
    /// @param player Address of the player to retrieve the achievements for
    /// @return uint256[] The IDs of the achievements unlocked by the player
    function getAchievementsOfPlayer(address player) external view returns (uint256[] memory) {
        uint256[] memory playerAchievementsList = new uint256[](totalAchievements);
        uint256 count;

        for (uint256 i; i < totalAchievements;) {
            if (playerAchievements[player][i]) {
                playerAchievementsList[count] = i;
                unchecked { ++count; }
            }
            unchecked { ++i; }
        }

        // Resize the array to fit the actual number of achievements
        uint256[] memory result = new uint256[](count);
        for (uint256 j; j < count;) {
            result[j] = playerAchievementsList[j];
            unchecked { ++j; }
        }

        return result;
    }
}
