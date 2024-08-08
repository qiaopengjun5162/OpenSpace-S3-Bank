// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Bank.sol";

contract BigBank is Bank {
    // Modifier: Deposit amount must be greater than 0.001 ether
    modifier onlyLargeDeposit() {
        require(msg.value > 0.001 ether, "Deposit amount must be greater than 0.001 ether");
        _;
    }

    // 重写 deposit 函数，增加 onlyLargeDeposit 修饰符
    function deposit() public payable virtual override onlyLargeDeposit {
        super.deposit();
    }

    // Function to set a new owner (only current owner can call)
    function transferOwnership(address _newOwner) public {
        require(_newOwner != address(0), "New owner is the zero address");
        owner = _newOwner;
    }

    // 重写 withdraw 函数，使其只能由 newOwner 调用
    function withdraw(address user, uint256 amount) public override(Bank) {
        require(msg.sender == owner, "Only new owner can call this function withdraw");
        super.withdraw(user, amount);
    }
}
