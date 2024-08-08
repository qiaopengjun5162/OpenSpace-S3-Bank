// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BigBank.sol";

contract Ownable {
    address public owner;
    BigBank public bigBank;

    // 构造函数，设置合约所有者为部署者，并初始化 BigBank 合约实例
    constructor(BigBank _bigBank) {
        owner = msg.sender;
        bigBank = _bigBank;

        // 调用 BigBank 的 transferOwnership 函数，将所有权转移到 Ownable 合约
        bigBank.transferOwnership(address(this));
    }

    // Modifier: Only owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function Ownable");
        _;
    }

    // Function to withdraw from BigBank (only owner can call)
    function withdrawFromBigBank(address user, uint256 amount) public onlyOwner {
        bigBank.withdraw(user, amount);
    }
}
