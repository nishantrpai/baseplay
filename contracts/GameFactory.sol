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

    /// @notice Creates a new game contract and adds it to the games array
    /// @param _gameName The name of the new game
    /// @param _gameDescription A brief description of the new game
    function createGame(string memory _gameName, string memory _gameDescription) public {
        Game newGame = new Game(msg.sender, _gameName, _gameDescription);
        emit GameCreated(address(newGame), _gameName, _gameDescription);
        games.push(GameInfo(address(newGame), _gameName, _gameDescription));
    }

    /// @notice Retrieves all created games
    /// @return An array of GameInfo structs containing information about all games
    function getAllGames() public view returns (GameInfo[] memory) {
        return games;
    }

    /// @notice Gets the description of a specific game
    /// @param index The index of the game in the games array
    /// @return The description of the specified game
    function getGameDescription(uint256 index) public view returns (string memory) {
        require(index < games.length, "Game index out of bounds");
        return Game(games[index].gameAddress).getGameDescription();
    }

    /// @notice Gets the name of a specific game
    /// @param index The index of the game in the games array
    /// @return The name of the specified game
    function getGameName(uint256 index) public view returns (string memory) {
        require(index < games.length, "Game index out of bounds");
        return Game(games[index].gameAddress).getGameName();
    }
}