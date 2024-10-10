const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("GameFactory", function () {
    let GameFactory;
    let gameFactory;
    let owner;
    let player1;
    let player2;

    beforeEach(async function () {
        [owner, player1, player2] = await ethers.getSigners();
        GameFactory = await ethers.getContractFactory("GameFactory");
        gameFactory = await GameFactory.deploy();
        await gameFactory.waitForDeployment();
    });

    it("should create a new game and emit GameCreated event", async function () {
        const gameName = "Test Game";
        const gameDescription = "This is a test game description";
        const gameLink = "https://example.com/test-game";
        
        await expect(gameFactory.createGame(gameName, gameDescription, gameLink))
            .to.emit(gameFactory, "GameCreated")
            .withArgs(ethers.isAddress, gameName, gameDescription);

        const games = await gameFactory.getAllGames();
        console.log("Games after creation:", games);
        expect(games.length).to.equal(1);
        expect(games[0].gameName).to.equal(gameName);
        expect(games[0].gameDescription).to.equal(gameDescription);
        expect(games[0].gameLink).to.equal(gameLink);
        expect(games[0].owner).to.equal(owner.address);
        expect(ethers.isAddress(games[0].gameAddress)).to.be.true;
    });

    it("should fetch all games", async function () {
        const gameName1 = "Test Game 1";
        const gameDescription1 = "This is a test game description 1";
        const gameLink1 = "https://example.com/test-game-1";
        const gameName2 = "Test Game 2";
        const gameDescription2 = "This is a test game description 2";
        const gameLink2 = "https://example.com/test-game-2";

        await gameFactory.createGame(gameName1, gameDescription1, gameLink1);
        await gameFactory.createGame(gameName2, gameDescription2, gameLink2);

        const games = await gameFactory.getAllGames();
        console.log("All games:", games);
        expect(games.length).to.equal(2);
        expect(games[0].gameName).to.equal(gameName1);
        expect(games[0].gameDescription).to.equal(gameDescription1);
        expect(games[0].gameLink).to.equal(gameLink1);
        expect(games[0].owner).to.equal(owner.address);
        expect(games[1].gameName).to.equal(gameName2);
        expect(games[1].gameDescription).to.equal(gameDescription2);
        expect(games[1].gameLink).to.equal(gameLink2);
        expect(games[1].owner).to.equal(owner.address);
        expect(ethers.isAddress(games[0].gameAddress)).to.be.true;
        expect(ethers.isAddress(games[1].gameAddress)).to.be.true;
    });

    it("should return an empty array when no games are created", async function () {
        const games = await gameFactory.getAllGames();
        console.log("Games when none created:", games);
        expect(games.length).to.equal(0);
    });

    it("should get game info by index", async function () {
        const gameName = "Test Game";
        const gameDescription = "This is a test game description";
        const gameLink = "https://example.com/test-game";

        await gameFactory.createGame(gameName, gameDescription, gameLink);

        const gameInfo = await gameFactory.getGameInfo(0);
        expect(gameInfo.gameName).to.equal(gameName);
        expect(gameInfo.gameDescription).to.equal(gameDescription);
        expect(gameInfo.gameLink).to.equal(gameLink);
        expect(gameInfo.owner).to.equal(owner.address);
        expect(ethers.isAddress(gameInfo.gameAddress)).to.be.true;
    });

    it("should get game count", async function () {
        expect(await gameFactory.getGameCount()).to.equal(0);

        await gameFactory.createGame("Game 1", "Description 1", "Link 1");
        expect(await gameFactory.getGameCount()).to.equal(1);

        await gameFactory.createGame("Game 2", "Description 2", "Link 2");
        expect(await gameFactory.getGameCount()).to.equal(2);
    });
});
