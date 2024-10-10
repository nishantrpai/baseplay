// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./Game.sol";

contract GameFactory {
    event GameCreated(address indexed gameAddress, string gameName, string gameDescription);
    
    struct GameInfo {
        address gameAddress;
        string gameName;
        string gameDescription;
        string gameLink;
        address owner;
    }

    GameInfo[] private games;

    function createGame(string memory _gameName, string memory _gameDescription, string memory _gameLink) external returns (bool) {
        Game newGame = new Game(msg.sender, _gameName, _gameDescription, _gameLink);
        emit GameCreated(address(newGame), _gameName, _gameDescription);
        games.push(GameInfo(address(newGame), _gameName, _gameDescription, _gameLink, msg.sender));
        return true;
    }

    function getAllGames() external view returns (GameInfo[] memory) {
        return games;
    }

    function getGameInfo(uint256 index) external view returns (GameInfo memory) {
        require(index < games.length, "Game index out of bounds");
        return games[index];
    }

    function getGameCount() external view returns (uint256) {
        return games.length;
    }
}