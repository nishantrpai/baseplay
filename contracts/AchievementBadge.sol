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

    function setBadgeURI(string memory newBadgeURI) public onlyOwner {
        _badgeURI = newBadgeURI;
    }

    function setDescription(string memory newDescription) public onlyOwner {
        _description = newDescription;
    }

    function mint(address player) public onlyOwner returns (uint256) {
        _tokenIds++;
        uint256 newTokenId = _tokenIds;
        _safeMint(player, newTokenId);
        _achievedCount++;
        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(tokenId > 0 && tokenId <= _tokenIds, "Invalid token ID");
        return _badgeURI;
    }

    function getDescription() public view returns (string memory) {
        return _description;
    }

    function getAchievedCount() public view returns (uint256) {
        return _achievedCount;
    }
}
