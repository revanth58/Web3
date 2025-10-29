// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PaymentVault
 * @dev Minimal contract to store and view Ether deposits.
 */
contract PaymentVault {
    mapping(address => uint256) public balances;

    /**
     * @dev Deposit Ether into the vault.
     */
    function deposit() external payable {
        require(msg.value > 0, "Send Ether to deposit");
        balances[msg.sender] += msg.value;
    }

    /**
     * @dev View total Ether balance stored in the contract.
     */
    function getVaultBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
