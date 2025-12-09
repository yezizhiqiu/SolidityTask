// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BeggingContract is Ownable {
    mapping(address => uint256) public donations;
    uint256 public totalDonations;
    uint256 public donorCount;
    address[] public donors;
    mapping(address => bool) private isDonor;
    
    uint256 public donationStartTime;
    uint256 public donationEndTime;
    
    event Donation(address indexed donor, uint256 amount, uint256 timestamp);
    event Withdrawal(address indexed owner, uint256 amount, uint256 timestamp);
    
    constructor(address initialOwner) Ownable(initialOwner) {}
    
    receive() external payable {
        totalDonations += msg.value;
        emit Donation(address(0), msg.value, block.timestamp);
    }
    
    // ========== 修饰器 ==========
    modifier validDonation() {
        require(msg.value > 0, "Donation amount must be greater than 0");
        _;
    }
    
    modifier withinDonationPeriod() {
        require(isDonationPeriod(), "Not in donation period");
        _;
    }
    
    // ========== 内部处理函数 ==========
    function _processDonation(address donor, uint256 amount) private {
        donations[donor] += amount;
        totalDonations += amount;
        
        if (!isDonor[donor]) {
            donors.push(donor);
            isDonor[donor] = true;
            donorCount++;
        }
        
        emit Donation(donor, amount, block.timestamp);
    }
    
    // ========== 捐赠函数 ==========
    function donate() external payable validDonation {
        _processDonation(msg.sender, msg.value);
    }
    
    function donateWithTimeLimit() external payable validDonation withinDonationPeriod {
        _processDonation(msg.sender, msg.value);
    }
    
    // ========== 其他函数 ==========
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        payable(owner()).transfer(balance);
        emit Withdrawal(msg.sender, balance, block.timestamp);
    }
    
    function getDonation(address donor) external view returns (uint256) {
        return donations[donor];
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    function isDonationPeriod() public view returns (bool) {
        if (donationStartTime == 0 && donationEndTime == 0) return true;
        return block.timestamp >= donationStartTime && block.timestamp <= donationEndTime;
    }
    
    function setDonationPeriod(uint256 startTime, uint256 endTime) external onlyOwner {
        require(startTime < endTime, "Start time must be before end time");
        donationStartTime = startTime;
        donationEndTime = endTime;
    }
}