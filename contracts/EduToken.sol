// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EduToken is ERC20 {
    address public admin;

    constructor(uint256 initialSupply) ERC20("EduToken", "EDU") {
        _mint(msg.sender, initialSupply);
        admin = msg.sender;
    }

    /// @notice Mint reward tokens to a student (only admin)
    function mintReward(address student, uint256 amount) external {
        require(msg.sender == admin, "Only admin can mint rewards");
        _mint(student, amount);
    }

    /// @notice Redeem tokens (burn from caller’s balance)
    function redeem(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    /// @notice Transfer admin rights to a new address
    function changeAdmin(address newAdmin) external {
        require(msg.sender == admin, "Only current admin can change admin");
        require(newAdmin != address(0), "New admin cannot be zero address");
        admin = newAdmin;
    }
}
