// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AchievementBadge is ERC721, Ownable {
    uint256 private _tokenIds;
    string private _badgeURI;
    string private _description;
    uint256 private _achievedCount;

    constructor(string memory description, string memory badgeURI) ERC721("Achievement Badge", "BADGE") Ownable(msg.sender) {
        _description = description;
        _badgeURI = badgeURI;
    }

    /// @notice Sets a new URI for the badge
    /// @param newBadgeURI The new URI to set for the badge
    function setBadgeURI(string memory newBadgeURI) public onlyOwner {
        _badgeURI = newBadgeURI;
    }

    /// @notice Sets a new description for the achievement
    /// @param newDescription The new description to set for the achievement
    function setDescription(string memory newDescription) public onlyOwner {
        _description = newDescription;
    }

    /// @notice Mints a new achievement badge for a player
    /// @param player The address of the player to mint the badge for
    /// @return The ID of the newly minted token
    function mint(address player) public onlyOwner returns (uint256) {
        _tokenIds++;
        uint256 newTokenId = _tokenIds;
        _safeMint(player, newTokenId);
        _achievedCount++;
        return newTokenId;
    }

    /// @notice Returns the URI for a given token ID
    /// @param tokenId The ID of the token to get the URI for
    /// @return The URI string for the given token ID
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(tokenId > 0 && tokenId <= _tokenIds, "Invalid token ID");
        return _badgeURI;
    }

    /// @notice Gets the description of the achievement
    /// @return The description string of the achievement
    function getDescription() public view returns (string memory) {
        return _description;
    }

    /// @notice Gets the total count of achievements awarded
    /// @return The total number of achievements that have been awarded
    function getAchievedCount() public view returns (uint256) {
        return _achievedCount;
    }
}
