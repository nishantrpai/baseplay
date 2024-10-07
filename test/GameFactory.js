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
        
        await expect(gameFactory.createGame(gameName, gameDescription))
            .to.emit(gameFactory, "GameCreated")
            .withArgs(ethers.isAddress, gameName, gameDescription);

        const games = await gameFactory.getAllGames();
        console.log("Games after creation:", games);
        expect(games.length).to.equal(1);
        expect(games[0].gameName).to.equal(gameName);
        expect(ethers.isAddress(games[0].gameAddress)).to.be.true;
    });

    it("should fetch all games", async function () {
        const gameName1 = "Test Game 1";
        const gameDescription1 = "This is a test game description 1";
        const gameName2 = "Test Game 2";
        const gameDescription2 = "This is a test game description 2";

        await gameFactory.createGame(gameName1, gameDescription1);
        await gameFactory.createGame(gameName2, gameDescription2);

        const games = await gameFactory.getAllGames();
        console.log("All games:", games);
        expect(games.length).to.equal(2);
        expect(games[0].gameName).to.equal(gameName1);
        expect(games[1].gameName).to.equal(gameName2);
        expect(ethers.isAddress(games[0].gameAddress)).to.be.true;
        expect(ethers.isAddress(games[1].gameAddress)).to.be.true;
    });

    it("should return an empty array when no games are created", async function () {
        const games = await gameFactory.getAllGames();
        console.log("Games when none created:", games);
        expect(games.length).to.equal(0);
    });
});
