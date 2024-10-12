# 🎮 Baseplay

![Baseplay Logo](baseplay.png)

🚀 Baseplay is an alternative to Google Play Games on Base. It allows devs to easily add achievements, leaderboards on the base chain without having to worry about databases, auth, and security.

Players can showcase their achievements and leaderboards directly on Base.

Devs can see how many players have joined their game, and what achievements they have completed from the dashboard.

## 🤔 Why?

One of my friends is currently building a game using on-chain nfts(scapes, mfers), and he mentioned that managing databases, auth, and security costs him time and money.

I used to build games on Android, and I was used to Google Play Games, so I thought of creating a similar experience on Base.

On Android, Google Play Games is the de-facto standard for adding achievements and leaderboards to games.

🏆 Baseplay provides on-chain services like leaderboards and achievements, similar to Google Play Games for Android.

⛓️ Our community prefers on-chain solutions, making Baseplay an ideal platform for blockchain gaming.

## 🛠️ How to Use

1. Go to the [Baseplay Dashboard](https://baseplay.vercel.app/index.html)
2. Create a new game by clicking on "Create Game"
3. Fill in the required details for your game
4. Once created, you can view your game or click on "My Games" to see all your created games

If you want to verify the contract on [sepolia](https://base-sepolia.blockscout.com/address/0xccBDDaf9aDCEe8b2005557dd6352A0AC55B963A5?tab=contract)

### 🚀 Setup in game

To integrate Baseplay into your game:

1. Include the Baseplay service script in your HTML file:
   ```html
   <script id="baseplay-service" src="https://baseplay.vercel.app/service.js?gameId=YOUR_GAME_ADDRESS"></script>
   ```
   Replace `YOUR_GAME_ADDRESS` with your actual game contract address.

2. Use the provided functions to manage achievements, leaderboards, and scores. 

For a detailed example of how to use these functions, check out our [example implementation](https://baseplay.vercel.app/example.html?gameId=0x326A2498A19f2AfA60EDECbc49BB785fa4cE3297).

### 🏆 Adding Achievements

1. Go to your game's page on the dashboard
2. Click on "Add Achievement"
3. Fill in the achievement details (name, description, image)
4. The image should be at least 30x30 pixels

## 📋 To-Do List

### Completed
- Get my games in gamefactory
- Get total players for a game
- Get leaderboard on game
- Add link for game, on click it opens game
- Get all achievements and players who achieved them
- When a user views the leaderboard, they should see the achievements they have achieved
- Get owner and show on game page
- Finish create game page
- Add achievements to game from dashboard
- Make extension that allows to connect contract and allows dev to add achievements/leaderboards etc
- Fix the issue with localhost
- All achievements are saved on localstorage by default, if player wants to save on-chain, devs can add option to save on-chain
- Add leaderboard to the extension similar to achievements
- Check on testnet

### Remaining by priority:
- Add screenshot to README
- Verify signature in contract to avoid players directly interacting with contract
- Use onchainkit
- Use smart wallets
- Use coinbase wallet for demo

## 🚧 Blockers/Concerns

1. What if players interact directly with contract, for e.g., setting leaderboard?

We're working on implementing signature verification in the contract to prevent direct interaction.

For more information and updates, stay tuned to our documentation and GitHub repository.