// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {
    address public owner;
    uint public betAmount;
    uint public totalBet;
    uint public numberOfBets;
    address[] public players;

    enum BetChoice {Heads, Tails}

    struct Bet {
        address player;
        BetChoice choice;
    }

    mapping(uint => Bet) public bets;

    event BetPlaced(address indexed player, uint indexed betIndex, BetChoice choice);

    constructor(uint _betAmount) {
        owner = msg.sender;
        betAmount = _betAmount;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier validBetChoice(BetChoice _choice) {
        require(_choice == BetChoice.Heads || _choice == BetChoice.Tails, "Invalid bet choice");
        _;
    }

    function placeBet(BetChoice _choice) external payable validBetChoice(_choice) {
        require(msg.value == betAmount, "Incorrect bet amount");

        bets[numberOfBets] = Bet(msg.sender, _choice);
        players.push(msg.sender);

        totalBet += msg.value;
        numberOfBets++;

        emit BetPlaced(msg.sender, numberOfBets - 1, _choice);
    }

    function flipCoin() external onlyOwner {
        // Simulate a coin flip
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players.length))) % 2;
        BetChoice winningChoice = BetChoice(random);

        // Determine the winner
        address winner;
        for (uint i = 0; i < numberOfBets; i++) {
            if (bets[i].choice == winningChoice) {
                winner = bets[i].player;
                break;
            }
        }

        // Transfer the funds to the winner
        if (winner != address(0)) {
            payable(winner).transfer(totalBet);
        }

        // Reset game state
        totalBet = 0;
        numberOfBets = 0;
        delete players;
    }

    function withdrawFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
