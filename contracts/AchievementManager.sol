// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./AchievementBadge.sol";

contract AchievementManager {
    struct Achievement {
        string description;
        string imageURI;
        AchievementBadge badge;
    }

    mapping(uint256 => Achievement) public achievements;
    mapping(address => mapping(uint256 => bool)) public playerAchievements;

    event AchievementUnlocked(address player, uint256 achievementId);
    event AchievementAdded(uint256 achievementId, string description, string imageURI);

    function addAchievement(uint256 achievementId, string memory description, string memory imageURI) public {
        AchievementBadge newBadge = new AchievementBadge(description, imageURI);
        achievements[achievementId] = Achievement(description, imageURI, newBadge);
        emit AchievementAdded(achievementId, description, imageURI);
    }

    function unlockAchievement(address player, uint256 achievementId) public {
        require(bytes(achievements[achievementId].description).length > 0, "Achievement does not exist");
        require(!playerAchievements[player][achievementId], "Achievement already unlocked");
        
        playerAchievements[player][achievementId] = true;
        achievements[achievementId].badge.mint(player);
        emit AchievementUnlocked(player, achievementId);
    }

    function hasAchievement(address player, uint256 achievementId) public view returns (bool) {
        return playerAchievements[player][achievementId];
    }

    function getAchievement(uint256 achievementId) public view returns (string memory description, string memory imageURI) {
        Achievement memory achievement = achievements[achievementId];
        return (achievement.description, achievement.imageURI);
    }
}
