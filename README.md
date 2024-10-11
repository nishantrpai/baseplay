# 🎮 Baseplay

🚀 Baseplay is a platform for creating and playing games on the Base blockchain.

# 🤔 Why?

💎 People want to use their onchain assets to build games, but managing databases, auth, and security is time-consuming.

🏆 Baseplay provides on-chain services like leaderboards and achievements, similar to Google Play Games for Android.

⛓️ Our community prefers on-chain solutions, making Baseplay an ideal platform for blockchain gaming.

# 🛠️ How

💻 Use the web app to create your game and deploy a contract to Base.

🏅 Connect to the contract using our library to manage game state, achievements, and leaderboards.

# Blockers/Concerns

1. What if players interact directly with contract, for e.g., setting leaderboard?

# To do:

Includes dashboard, extension and contract.

Contract:
- Game preview link from ipfs can be added to the contract (later, not needed for now)
- Avoid spam with $8/game submission that way no one can spam the games
- ~~Add a game url to game.sol so it avoids so script works on that domain or localhost~~
- ~~Accelerate dev process with localhost for hardhat~~
- Verify signature in contract to avoid players directly interacting with contract
- Check on testnet
- Remove the drop of achievement, we only want to keep a transaction on chain without signing it

Dashboard:
- ~~Get my games in gamefactory~~
- ~~Get total players for a game~~
- ~~Get leaderboard on game~~
- ~~Add link for game, on click it opens game~~
- ~~Get all achievements and players who achieved them~~
- ~~When a user views the leaderboard, they should see the achievements they have achieved~~
- ~~Get owner and show on game page~~
- ~~Finish create game page~~
- ~~Add achievements to game from dashboard~~
- Check on testnet

Extension:
- ~~Make extension that allows to connect contract and allows dev to add achievements/leaderboards etc~~
- Check on testnet
- ~~Failing on localhost for some reason, need to debug~~
- All achievements are saved on localstorage by default, if player wants to save on chain, devs can add option to save on chain

- Documentation notes:
  - img should be >= 30x30

TODO: 
- Use onchainkit
- Use smart wallets