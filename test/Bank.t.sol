// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";

contract BankTest is Test {
    Bank public bank;

    function setUp() public {
        bank = new Bank();
    }

    function testDeposit() public {
        // 为当前合约账户提供1 ether
        vm.deal(address(this), 1 ether);
        // 调用 deposit() 并发送1 ether
        bank.deposit{value: 1 ether}();
        // 检查合约中记录的余额是否正确
        assertEq(bank.balances(address(this)), 1 ether);
    }

    function testWithdraw() public {
        address user1 = address(0x123);
        // 为用户1账户提供1 ether
        vm.deal(user1, 1 ether);
        assertEq(address(user1).balance, 1 ether);
        vm.prank(address(user1));
        // 调用 deposit() 并发送1 ether
        bank.deposit{value: 1 ether}();

        // 检查用户1账户余额是否减少
        assertEq(address(user1).balance, 0);

        // 检查合约余额是否增加
        assertEq(bank.balances(user1), 1 ether);
        // 检查合约所有者账户余额是否增加
        assertEq(address(bank).balance, 1 ether);

        // 使用合约所有者调用 withdraw() 提取1 ether
        vm.prank(bank.owner());
        bank.withdraw(user1, 1 ether);
        // 检查合约所有者账户余额是否减少
        // assertEq(address(this).balance, 0, "Withdraw failed");
        // 检查合约余额是否减少
        assertEq(address(bank).balance, 0);

        // 检查用户1账户余额是否增加
        assertEq(address(user1).balance, 1 ether, "Withdraw failed");
    }

    function testWithdrawNonOwner() public {
        address user1 = address(0x456);
        vm.deal(user1, 1 ether);
        vm.prank(address(user1));
        // 调用 deposit() 并发送1 ether
        bank.deposit{value: 1 ether}();
        assertEq(bank.balances(user1), 1 ether);
        vm.prank(address(user1));
        // 非合约所有者尝试调用 withdraw()，应当失败
        vm.expectRevert("Only owner can call this function");
        bank.withdraw(user1, 1 ether);
    }

    function testTopDepositUsers() public {
        // 模拟多个账户进行存款
        address addr1 = address(0x123);
        address addr2 = address(0x456);
        address addr3 = address(0x789);

        vm.deal(addr1, 1 ether);
        vm.prank(addr1);
        bank.deposit{value: 1 ether}();

        vm.deal(addr2, 2 ether);
        vm.prank(addr2);
        bank.deposit{value: 2 ether}();

        vm.deal(addr3, 3 ether);
        vm.prank(addr3);
        bank.deposit{value: 3 ether}();

        (address[3] memory topUsers, uint256[3] memory topAmounts) = bank.getTopDepositUsers();
        assertEq(topUsers[0], addr3);
        assertEq(topUsers[1], addr2);
        assertEq(topUsers[2], addr1);

        assertEq(topAmounts[0], 3 ether);
        assertEq(topAmounts[1], 2 ether);
        assertEq(topAmounts[2], 1 ether);
    }
}
