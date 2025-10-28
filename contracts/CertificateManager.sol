// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CertificateManager
/// @notice A minimal smart contract to issue and verify learning certificates
contract CertificateManager {
    address public owner;

    struct Certificate {
        string courseName;
        uint256 dateIssued;
    }

    mapping(address => Certificate[]) private studentCertificates;

    event CertificateIssued(address indexed student, string courseName);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    /// @notice Issue a certificate to a student
    function issueCertificate(address student, string calldata courseName) external onlyOwner {
        studentCertificates[student].push(Certificate(courseName, block.timestamp));
        emit CertificateIssued(student, courseName);
    }

    /// @notice View all certificates issued to a student
    function getCertificates(address student) external view returns (Certificate[] memory) {
        return studentCertificates[student];
    }

    /// @notice Transfer contract ownership to another address
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
