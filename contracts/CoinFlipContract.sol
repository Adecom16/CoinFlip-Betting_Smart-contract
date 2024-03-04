// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CoinFlip.sol"; 
contract CoinFlipFactory {
    address[] public deployedCoinFlips;

    event CoinFlipDeployed(address indexed coinFlip, address indexed owner, uint betAmount);

    function createCoinFlip(uint _betAmount) external {
        address newCoinFlip = address(new CoinFlip(_betAmount)); 
        deployedCoinFlips.push(newCoinFlip); 
        emit CoinFlipDeployed(newCoinFlip, msg.sender, _betAmount); 
    }

    function getDeployedCoinFlips() external view returns (address[] memory) {
        return deployedCoinFlips;
    }
}
