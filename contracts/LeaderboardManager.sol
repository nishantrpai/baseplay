// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract LeaderboardManager {
    struct LeaderboardEntry {
        address player;
        uint256 score;
    }

    mapping(address => LeaderboardEntry[10]) public gameLeaderboards;
    
    event LeaderboardUpdated(address indexed game, address indexed player, uint256 score, uint256 position);

    function updateLeaderboard(address game, address player, uint256 score) public {
        LeaderboardEntry[10] storage leaderboard = gameLeaderboards[game];
        uint256 position = _findPosition(leaderboard, score);

        if (position < 10) {
            // Shift lower scores down
            for (uint256 i = 9; i > position; i--) {
                leaderboard[i] = leaderboard[i-1];
            }
            // Insert new high score
            leaderboard[position] = LeaderboardEntry(player, score);
            emit LeaderboardUpdated(game, player, score, position + 1);
        }
    }

    function getTopPlayers(address game) public view returns (LeaderboardEntry[10] memory) {
        return gameLeaderboards[game];
    }

    function _findPosition(LeaderboardEntry[10] storage leaderboard, uint256 score) private view returns (uint256) {
        for (uint256 i = 0; i < 10; i++) {
            if (score > leaderboard[i].score) {
                return i;
            }
        }
        return 10;
    }

    function removePlayerFromLeaderboard(address game, address player) public {
        LeaderboardEntry[10] storage leaderboard = gameLeaderboards[game];
        for (uint256 i = 0; i < 10; i++) {
            if (leaderboard[i].player == player) {
                // Shift lower scores up
                for (uint256 j = i; j < 9; j++) {
                    leaderboard[j] = leaderboard[j+1];
                }
                leaderboard[9] = LeaderboardEntry(address(0), 0);
                break;
            }
        }
    }
}
