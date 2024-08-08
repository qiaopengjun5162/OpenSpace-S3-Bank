// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * 编写一个 Bank 存款合约，实现功能：
 * 可以通过 Metamask 等钱包直接给 Bank 合约地址存款
 * 在 Bank 合约里记录了每个地址的存款金额
 * 用可迭代的链表保存存款金额的前 10 名用户
 */
contract Bank {
    // Structure to hold depositor information
    struct Depositor {
        address user;
        uint256 amount;
    }

    // Mapping to store each user's deposit amount
    mapping(address => uint256) public deposits;
    // Mapping to manage linked list of depositors
    mapping(address => address) private _nextDepositors;
    // Current size of the linked list
    uint256 public listSize;
    // Sentinel node to simplify linked list operations
    address constant GUARD = address(1);
    // Maximum number of top depositors to track
    uint256 public constant TOP_LIMIT = 10;

    constructor() {
        // Initialize the sentinel node to point to itself
        _nextDepositors[GUARD] = GUARD;
    }

    // Event emitted when a deposit is made
    event Deposit(address indexed user, uint256 amount);
    // Event emitted when the list of top depositors is updated
    event TopDepositorsUpdated(address indexed user, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");

        // Update the deposit amount for the sender
        uint256 newDepositAmount = deposits[msg.sender] + msg.value;
        deposits[msg.sender] = newDepositAmount;

        // Update the list of top depositors
        _updateTopDepositors(msg.sender, newDepositAmount);

        emit Deposit(msg.sender, msg.value);
    }

    function _updateTopDepositors(address user, uint256 newAmount) internal {
        require(_nextDepositors[user] != address(0) || newAmount > 0, "Invalid operation");

        // If the user is already in the list, remove them from their old position
        if (_nextDepositors[user] != address(0)) {
            // Remove from old position
            _removeDepositor(user);
        }

        // Add the user to their new position
        _addDepositor(user, newAmount);
    }

    function _addDepositor(address user, uint256 amount) internal {
        address current = GUARD;

        // Find the correct position in the list where the new amount should be inserted
        while (_nextDepositors[current] != GUARD && deposits[_nextDepositors[current]] >= amount) {
            current = _nextDepositors[current];
        }

        // Insert the user in the list
        _nextDepositors[user] = _nextDepositors[current];
        _nextDepositors[current] = user;
        listSize++;

        // Ensure the list size does not exceed the limit
        if (listSize > TOP_LIMIT) {
            address toRemove = _nextDepositors[GUARD];
            _removeDepositor(toRemove);
        }

        emit TopDepositorsUpdated(user, amount);
    }

    function _removeDepositor(address user) internal {
        require(_nextDepositors[user] != address(0), "User not found");

        address prev = GUARD;
        // Find the previous node of the user to be removed
        while (_nextDepositors[prev] != user) {
            prev = _nextDepositors[prev];
        }

        _nextDepositors[prev] = _nextDepositors[user];
        _nextDepositors[user] = address(0);
        deposits[user] = 0;
        listSize--;
    }

    function getTop(uint256 k) external view returns (address[] memory) {
        require(k <= TOP_LIMIT, "k exceeds limit");
        require(k <= listSize, "Not enough depositors");

        address[] memory topList = new address[](k);
        address current = _nextDepositors[GUARD];
        // Collect the addresses of the top k depositors
        for (uint256 i = 0; i < k; i++) {
            topList[i] = current;
            current = _nextDepositors[current];
        }
        return topList;
    }

    receive() external payable {
        deposit();
    }
}
