// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EDUTOKEN {
    mapping(address => uint256) public balances; // token balance per address
    mapping(address => bool) public rewarded;    // track if student rewarded
    address public owner;                        // contract owner
    uint256 public totalMinted;                  // total tokens minted
    uint256 public totalBurned;                  // total tokens burned

    event TokensMinted(address indexed to, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event StudentRewarded(address indexed student, uint256 amount);

    constructor() {
        owner = msg.sender; // set deployer as owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        balances[to] += amount;
        totalMinted += amount;
        emit TokensMinted(to, amount);
    }

    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit TokensTransferred(msg.sender, to, amount);
    }

    function burn(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        totalBurned += amount;
        emit TokensBurned(msg.sender, amount);
    }

    function checkEligibility(address student) external view returns (string memory) {
        uint256 bal = balances[student];
        if (bal >= 1000) return "Eligible for scholarship";
        if (bal >= 500) return "Eligible for participation reward";
        return "Not eligible";
    }

    function rewardStudent(address student, uint256 amount) external onlyOwner {
        require(!rewarded[student], "Already rewarded");
        balances[student] += amount;
        totalMinted += amount;
        rewarded[student] = true;
        emit StudentRewarded(student, amount);
    }

    function getBalance(address account) external view returns (uint256) {
        return balances[account];
    }

    function totalSupply() external view returns (uint256) {
        return totalMinted - totalBurned;
    }
}
