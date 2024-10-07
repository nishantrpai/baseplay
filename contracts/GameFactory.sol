// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./Game.sol";

contract GameFactory {
    event GameCreated(address gameAddress, string gameName, string gameDescription);
    
    struct GameInfo {
        address gameAddress;
        string gameName;
        string gameDescription;
    }

    GameInfo[] public games;

    function createGame(string memory _gameName, string memory _gameDescription) public {
        Game newGame = new Game(msg.sender, _gameName, _gameDescription);
        emit GameCreated(address(newGame), _gameName, _gameDescription);
        games.push(GameInfo(address(newGame), _gameName, _gameDescription));
    }

    function getAllGames() public view returns (GameInfo[] memory) {
        return games;
    }
}