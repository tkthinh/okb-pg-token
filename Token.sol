// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    // Mapping to track the last withdrawal timestamp for each user
    mapping(address => uint256) private lastWithdrawalTime;

    // Event for withdrawal
    event Withdrawn(address indexed user, uint256 amount);

    constructor(uint256 initialSupply) ERC20("TestTokenB", "TTB") {
        // Mint initial supply to contract for withdrawals
        _mint(address(this), initialSupply * 1e6);
    }

    // Override decimals to return 6
    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

    // Function to allow user to withdraw 1 token (1 * 10^6 units) once per day
    function withdraw(uint256 amount, address rqAddress) external {
        // Check if user has waited 24 hours since last withdrawal
        require(
            block.timestamp >= lastWithdrawalTime[msg.sender] + 1 days,
            "Can only withdraw once per day"
        );

        // Check if contract has enough tokens
        require(balanceOf(address(this)) >= amount, "Contract has insufficient tokens");

        // Update last withdrawal time
        lastWithdrawalTime[rqAddress] = block.timestamp;

        // Transfer 1 token to user
        _transfer(address(this), rqAddress, amount * 1e6);

        // Emit event
        emit Withdrawn(rqAddress, amount);
    }

    // Optional: Function to check last withdrawal time for a user
    function getLastWithdrawalTime(address user) external view returns (uint256) {
        return lastWithdrawalTime[user];
    }
}