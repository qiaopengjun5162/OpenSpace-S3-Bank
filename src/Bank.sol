// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 定义 IBank 接口
interface IBank {
    function withdraw(address user, uint256 amount) external;
}

contract Bank {
    // owner：合约部署者即为合约的所有者，拥有撤回资金的权限。
    address public owner;
    // balances：mapping 类型，用于存储每个地址的存款金额。
    mapping(address => uint256) public balances;
    address[3] public topDepositUsers;

    // Deposit 事件，用于记录存款操作
    event Deposit(address indexed user, uint256 amount);
    // Withdraw 事件，用于记录提款操作
    event Withdraw(address indexed user, uint256 amount);

    // 构造函数，设置合约所有者为部署者
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function Bank");
        _;
    }

    // Deposit function
    function deposit() public payable virtual {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);

        // 更新前三名存款用户
        updateTopUsers(msg.sender);
    }

    // Withdraw function (only owner can call)
    function withdraw(address user, uint256 amount) public virtual onlyOwner {
        require(amount > 0, "Withdraw amount must be greater than 0");
        require(amount <= address(this).balance, "Insufficient contract balance");

        payable(user).transfer(amount);
        emit Withdraw(user, amount);
    }

    // Internal function to update top deposit users
    function updateTopUsers(address user) internal {
        uint256 userBalance = balances[user];

        // 检查用户是否已经在前三名中
        for (uint256 i = 0; i < topDepositUsers.length; i++) {
            if (user == topDepositUsers[i]) {
                sortTopUsers();
                return;
            }
        }

        // 如果用户不在前三名且当前存款大于第三名
        if (userBalance > balances[topDepositUsers[2]]) {
            topDepositUsers[2] = user;
            sortTopUsers();
        }
    }

    // Sort the top deposit users
    function sortTopUsers() internal {
        for (uint256 i = 0; i < topDepositUsers.length - 1; i++) {
            for (uint256 j = i + 1; j < topDepositUsers.length; j++) {
                if (balances[topDepositUsers[i]] < balances[topDepositUsers[j]]) {
                    address tempUser = topDepositUsers[i];
                    topDepositUsers[i] = topDepositUsers[j];
                    topDepositUsers[j] = tempUser;
                }
            }
        }
    }

    // View function to get top deposit users and amounts
    function getTopDepositUsers() external view returns (address[3] memory, uint256[3] memory) {
        uint256[3] memory topAmounts;
        for (uint256 i = 0; i < topDepositUsers.length; i++) {
            topAmounts[i] = balances[topDepositUsers[i]];
        }
        return (topDepositUsers, topAmounts);
    }

    // Fallback function to receive Ether
    receive() external payable {
        deposit();
    }
}
