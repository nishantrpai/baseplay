const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("GameFactory", function () {
    let GameFactory;
    let gameFactory;
    let owner;

    beforeEach(async function () {
        [owner] = await ethers.getSigners();
        GameFactory = await ethers.getContractFactory("GameFactory");
        gameFactory = await GameFactory.deploy();
        await gameFactory.waitForDeployment();
    });

    it("should create a new game and emit GameCreated event", async function () {
        const gameName = "Test Game";
        const gameDescription = "This is a test game description";
        const gameLink = "https://example.com/test-game"; // Added game link
        
        await expect(gameFactory.createGame(gameName, gameDescription, gameLink))
            .to.emit(gameFactory, "GameCreated")
            .withArgs(ethers.isAddress, gameName, gameDescription);

        const games = await gameFactory.getAllGames();
        console.log("Games after creation:", games);
        expect(games.length).to.equal(1);
        expect(games[0].gameName).to.equal(gameName);
        expect(games[0].gameDescription).to.equal(gameDescription); // Check game description
        expect(games[0].gameLink).to.equal(gameLink); // Check game link
        expect(games[0].owner).to.equal(owner.address); // Check game owner
        expect(ethers.isAddress(games[0].gameAddress)).to.be.true;
    });

    it("should fetch all games", async function () {
        const gameName1 = "Test Game 1";
        const gameDescription1 = "This is a test game description 1";
        const gameLink1 = "https://example.com/test-game-1"; // Added game link
        const gameName2 = "Test Game 2";
        const gameDescription2 = "This is a test game description 2";
        const gameLink2 = "https://example.com/test-game-2"; // Added game link

        await gameFactory.createGame(gameName1, gameDescription1, gameLink1);
        await gameFactory.createGame(gameName2, gameDescription2, gameLink2);

        const games = await gameFactory.getAllGames();
        console.log("All games:", games);
        expect(games.length).to.equal(2);
        expect(games[0].gameName).to.equal(gameName1);
        expect(games[0].gameDescription).to.equal(gameDescription1); // Check game description
        expect(games[0].gameLink).to.equal(gameLink1); // Check game link
        expect(games[0].owner).to.equal(owner.address); // Check game owner
        expect(games[1].gameName).to.equal(gameName2);
        expect(games[1].gameDescription).to.equal(gameDescription2); // Check game description
        expect(games[1].gameLink).to.equal(gameLink2); // Check game link
        expect(games[1].owner).to.equal(owner.address); // Check game owner
        expect(ethers.isAddress(games[0].gameAddress)).to.be.true;
        expect(ethers.isAddress(games[1].gameAddress)).to.be.true;
    });

    it("should return an empty array when no games are created", async function () {
        const games = await gameFactory.getAllGames();
        console.log("Games when none created:", games);
        expect(games.length).to.equal(0);
    });
});
