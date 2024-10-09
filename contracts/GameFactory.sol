// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./Game.sol";

contract GameFactory {
    event GameCreated(address gameAddress, string gameName, string gameDescription);
    
    struct GameInfo {
        address gameAddress;
        string gameName;
        string gameDescription;
        string gameLink;
        address owner; // Added owner field to store the game owner's address
    }

    GameInfo[] public games;

    /// @notice Creates a new game contract and adds it to the games array
    /// @param _gameName The name of the new game
    /// @param _gameDescription A brief description of the new game
    /// @param _gameLink The link to the new game
    /// @return success A boolean indicating whether the game creation was successful
    function createGame(string memory _gameName, string memory _gameDescription, string memory _gameLink) public returns (bool success) {
        Game newGame = new Game(msg.sender, _gameName, _gameDescription, _gameLink);
        emit GameCreated(address(newGame), _gameName, _gameDescription);
        games.push(GameInfo(address(newGame), _gameName, _gameDescription, _gameLink, msg.sender)); // Store the owner's address
        return true;
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

    /// @notice Gets the link of a specific game
    /// @param index The index of the game in the games array
    /// @return The link of the specified game
    function getGameLink(uint256 index) public view returns (string memory) {
        require(index < games.length, "Game index out of bounds");
        return Game(games[index].gameAddress).getGameLink();
    }

    /// @notice Gets the owner of a specific game
    /// @param index The index of the game in the games array
    /// @return The address of the game owner
    function getGameOwner(uint256 index) public view returns (address) {
        require(index < games.length, "Game index out of bounds");
        return games[index].owner; // Return the owner's address directly from the GameInfo struct
    }
}