// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./AchievementBadge.sol";

/// @title AchievementManager
/// @notice Manages achievements and their associated badges for players
contract AchievementManager {
    /// @dev Struct to store achievement details
    struct Achievement {
        string description;
        string imageURI;
        AchievementBadge badge;
    }

    /// @dev Mapping of achievement IDs to Achievement structs
    mapping(uint256 => Achievement) public achievements;
    /// @dev Mapping of player addresses to their unlocked achievements
    mapping(address => mapping(uint256 => bool)) public playerAchievements;

    /// @dev Event emitted when a player unlocks an achievement
    event AchievementUnlocked(address player, uint256 achievementId);
    /// @dev Event emitted when a new achievement is added
    event AchievementAdded(uint256 achievementId, string description, string imageURI);

    /// @notice Adds a new achievement to the system
    /// @param achievementId Unique identifier for the achievement
    /// @param description Text description of the achievement
    /// @param imageURI URI of the image associated with the achievement
    function addAchievement(uint256 achievementId, string memory description, string memory imageURI) public {
        AchievementBadge newBadge = new AchievementBadge(description, imageURI);
        achievements[achievementId] = Achievement(description, imageURI, newBadge);
        emit AchievementAdded(achievementId, description, imageURI);
    }

    /// @notice Unlocks an achievement for a player
    /// @param player Address of the player unlocking the achievement
    /// @param achievementId ID of the achievement being unlocked
    function unlockAchievement(address player, uint256 achievementId) public {
        require(bytes(achievements[achievementId].description).length > 0, "Achievement does not exist");
        require(!playerAchievements[player][achievementId], "Achievement already unlocked");
        
        playerAchievements[player][achievementId] = true;
        achievements[achievementId].badge.mint(player);
        emit AchievementUnlocked(player, achievementId);
    }

    /// @notice Checks if a player has unlocked a specific achievement
    /// @param player Address of the player to check
    /// @param achievementId ID of the achievement to check
    /// @return bool indicating whether the player has unlocked the achievement
    function hasAchievement(address player, uint256 achievementId) public view returns (bool) {
        return playerAchievements[player][achievementId];
    }

    /// @notice Retrieves the details of a specific achievement
    /// @param achievementId ID of the achievement to retrieve
    /// @return description Text description of the achievement
    /// @return imageURI URI of the image associated with the achievement
    function getAchievement(uint256 achievementId) public view returns (string memory description, string memory imageURI) {
        Achievement memory achievement = achievements[achievementId];
        return (achievement.description, achievement.imageURI);
    }
}
