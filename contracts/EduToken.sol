// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


/// @title EDUTOKEN
/// @notice A minimal education-focused ERC-like token contract with owner-only minting,
///         simple transfers, burning, and a one-time student reward mechanism.
contract EDUTOKEN {
    // Token balance per address
    mapping(address => uint256) public balances;

    // Tracks which students have already received the one-time reward
    mapping(address => bool) public rewarded;

    // Contract owner (has permission to mint and issue rewards)
    address public owner;

    // Cumulative amounts minted and burned (used to compute total supply)
    uint256 public totalMinted;
    uint256 public totalBurned;

    // Events emitted for important state changes
    event TokensMinted(address indexed to, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event StudentRewarded(address indexed student, uint256 amount);

    /// @dev Sets the deployer as the contract owner
    constructor() {
        owner = msg.sender;
    }

    /// @notice Mint new tokens to a specified address
    /// @dev Only callable by the owner. Increases balances and totalMinted.
    /// @param to Recipient address
    /// @param amount Amount of tokens to mint
    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        balances[to] += amount;
        totalMinted += amount;
        emit TokensMinted(to, amount);
    }

    /// @notice Transfer tokens from caller to another address
    /// @dev Requires sufficient balance on the caller's account.
    /// @param to Recipient address
    /// @param amount Amount to transfer
    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit TokensTransferred(msg.sender, to, amount);
    }

    /// @notice Burn tokens from the caller's balance
    /// @dev Reduces caller balance and increases totalBurned.
    /// @param amount Amount to burn
    function burn(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance to burn");
        balances[msg.sender] -= amount;
        totalBurned += amount;
        emit TokensBurned(msg.sender, amount);
    }

    /// @notice Check a student's eligibility tier based on their token balance
    /// @dev Returns a human-readable string describing eligibility.
    /// @param student Address of the student to check
    /// @return A string indicating eligibility level
    function checkEligibility(address student) public view returns (string memory) {
        uint256 bal = balances[student];
        if (bal >= 1000) {
            return "Eligible for scholarship";
        } else if (bal >= 500) {
            return "Eligible for participation reward";
        } else {
            return "Not eligible";
        }
    }

    /// @notice Issue a one-time reward to a student
    /// @dev Only the owner can call this. Each student can receive this reward once.
    ///      Increases the student's balance and totalMinted, and marks them as rewarded.
    /// @param student Address of the student
    /// @param amount Amount of reward tokens to mint to the student
    function rewardStudent(address student, uint256 amount) public {
        require(msg.sender == owner, "Only owner can reward");
        require(!rewarded[student], "Student already rewarded");
        balances[student] += amount;
        totalMinted += amount;
        rewarded[student] = true;
        emit StudentRewarded(student, amount);
    }

    /// @notice Get the token balance for a given student/address
    /// @param student Address to query
    /// @return The token balance of the address
    function getBalance(address student) public view returns (uint256) {
        return balances[student];
    }

    /// @notice Compute the total token supply currently in circulation
    /// @dev totalSupply = totalMinted - totalBurned
    /// @return Current total supply
    function totalSupply() public view returns (uint256) {
        return totalMinted - totalBurned;
    }
}