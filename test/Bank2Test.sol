// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Bank} from "../src/Bank2.sol";

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
        assertEq(bank.deposits(address(this)), 1 ether);
    }

    // Test depositing funds and verifying the amount
    function testDepositSuccessful() public {
        // Provide 1 ether to the test contract
        vm.deal(address(this), 1 ether);
        // Call deposit() and send 1 ether
        bank.deposit{value: 1 ether}();
        // Check if the recorded deposit amount is correct
        assertEq(bank.deposits(address(this)), 1 ether);
    }

    // Test adding multiple depositors and check the top 10 list
    // function testTopDepositors() public {
    //     // Provide ethers to multiple accounts
    //     address[] memory accounts;
    //     for (uint256 i = 0; i < 12; i++) {
    //         accounts[i] = address(uint160(i + 2));
    //         vm.deal(accounts[i], 1 ether);
    //         vm.prank(accounts[i]);
    //         bank.deposit{value: (i + 1) * 1 ether}();
    //     }

    //     // Check the top 10 depositors
    //     address[] memory top10 = bank.getTop(10);

    //     // Verify the top 10 depositors (highest amounts should be at the start)
    //     for (uint256 i = 0; i < 10; i++) {
    //         assertEq(bank.deposits(top10[i]), (12 - i) * 1 ether);
    //     }
    // }

    // Test updating deposit amounts
    function testUpdateDeposit() public {
        // Provide 1 ether to the test contract
        vm.deal(address(this), 3 ether);
        bank.deposit{value: 1 ether}();
        assertEq(bank.deposits(address(this)), 1 ether);
        // Update the deposit amount
        bank.deposit{value: 2 ether}(); // Increases the total deposit to 3 ether

        // Verify the updated deposit amount
        assertEq(bank.deposits(address(this)), 0 ether);
    }

    // Test if deposits are properly reset on removal
    function testDepositMul() public {
        address account1 = address(2);
        address account2 = address(3);
        vm.deal(account1, 20 ether);
        vm.deal(account2, 10 ether);

        // Deposit amounts
        vm.prank(account1);
        bank.deposit{value: 5 ether}();
        assertEq(bank.deposits(address(account1)), 5 ether);
        vm.prank(account2);
        bank.deposit{value: 10 ether}();
        assertEq(bank.deposits(address(account2)), 10 ether);

        // Remove account1
        vm.prank(account1);
        vm.expectRevert("Deposit amount must be greater than 0");
        bank.deposit{value: 0 ether}();

        // Check the top depositors
        address[] memory top10 = bank.getTop(2);
        assertEq(bank.deposits(top10[0]), 10 ether); // account2 should be the top depositor
        assertEq(bank.deposits(top10[1]), 5 ether); // account1 should not be in the list
    }
}
