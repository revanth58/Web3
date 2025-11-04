// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EDUTOKEN {
    mapping(address => uint256) public balances;
    mapping(address => bool) public rewarded; // track who already got a reward
    address public owner;

    uint256 public totalMinted;
    uint256 public totalBurned;

    event TokensMinted(address indexed to, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event StudentRewarded(address indexed student, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // Mint new tokens (only owner)
    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        balances[to] += amount;
        totalMinted += amount;
        emit TokensMinted(to, amount);
    }

    // Transfer tokens between users
    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit TokensTransferred(msg.sender, to, amount);
    }

    // Burn tokens from caller
    function burn(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance to burn");
        balances[msg.sender] -= amount;
        totalBurned += amount;
        emit TokensBurned(msg.sender, amount);
    }

    // Check if a student is eligible for a reward based on token balance
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

    // Reward a student (only once)
    function rewardStudent(address student, uint256 amount) public {
        require(msg.sender == owner, "Only owner can reward");
        require(!rewarded[student], "Student already rewarded");
        balances[student] += amount;
        totalMinted += amount;
        rewarded[student] = true;
        emit StudentRewarded(student, amount);
    }

    // Get total balance of a student
    function getBalance(address student) public view returns (uint256) {
        return balances[student];
    }

    // get total supply in the system
    function totalSupply() public view returns (uint256) {
        return totalMinted - totalBurned;
    }
}
