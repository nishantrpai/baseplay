// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract LeaderboardManager {
    struct LeaderboardEntry {
        address player;
        uint256 score;
    }

    mapping(address => LeaderboardEntry[10]) private gameLeaderboards;
    
    event LeaderboardUpdated(address indexed game, address indexed player, uint256 score, uint256 position);

    function updateLeaderboard(address game, address player, uint256 score) external {
        LeaderboardEntry[10] storage leaderboard = gameLeaderboards[game];
        uint256 position;
        for (; position < 10; ++position) {
            if (score > leaderboard[position].score) break;
        }

        if (position < 10) {
            for (uint256 i = 9; i > position; --i) {
                leaderboard[i] = leaderboard[i - 1];
            }
            leaderboard[position] = LeaderboardEntry(player, score);
            emit LeaderboardUpdated(game, player, score, position + 1);
        }
    }

    function getTopPlayers(address game) external view returns (LeaderboardEntry[10] memory) {
        return gameLeaderboards[game];
    }

    function removePlayerFromLeaderboard(address game, address player) external {
        LeaderboardEntry[10] storage leaderboard = gameLeaderboards[game];
        for (uint256 i; i < 10;) {
            if (leaderboard[i].player == player) {
                for (uint256 j = i; j < 9; ++j) {
                    leaderboard[j] = leaderboard[j + 1];
                }
                leaderboard[9] = LeaderboardEntry(address(0), 0);
                break;
            }
            unchecked { ++i; }
        }
    }
}
