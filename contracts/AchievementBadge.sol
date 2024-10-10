// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AchievementBadge is ERC721 {
    uint256 private immutable _creationTime;
    uint256 private _tokenIds;
    string private _badgeURI;
    string private _description;
    uint256 private _achievedCount;
    address private immutable _owner;

    error Unauthorized();
    error InvalidTokenId();

    constructor(string memory description, string memory badgeURI) ERC721("Achievement Badge", "BADGE") {
        _description = description;
        _badgeURI = badgeURI;
        _owner = msg.sender;
        _creationTime = block.timestamp;
    }

    modifier onlyOwner() {
        if (msg.sender != _owner) revert Unauthorized();
        _;
    }

    function setBadgeURI(string calldata newBadgeURI) external onlyOwner {
        _badgeURI = newBadgeURI;
    }

    function setDescription(string calldata newDescription) external onlyOwner {
        _description = newDescription;
    }

    function mint(address player) external onlyOwner returns (uint256 newTokenId) {
        unchecked {
            newTokenId = ++_tokenIds;
            ++_achievedCount;
        }
        _safeMint(player, newTokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (tokenId == 0 || tokenId > _tokenIds) revert InvalidTokenId();
        return _badgeURI;
    }

    function getDescription() external view returns (string memory) {
        return _description;
    }

    function getAchievedCount() external view returns (uint256) {
        return _achievedCount;
    }

    function owner() external view returns (address) {
        return _owner;
    }

    function creationTime() external view returns (uint256) {
        return _creationTime;
    }
}
