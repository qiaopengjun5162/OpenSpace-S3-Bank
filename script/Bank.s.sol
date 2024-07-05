// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import "../src/Bank.sol";

contract BankScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // 获取部署者地址
        address deployer = msg.sender;

        // 开始广播交易（所有之后的操作都会被视为交易）
        vm.startBroadcast(deployerPrivateKey);

        // 部署 Bank 合约
        Bank bank = new Bank();

        // 停止广播交易
        vm.stopBroadcast();

        // 输出 Bank 合约地址
        console.log("Bank deployed to:", address(bank));
    }
}

/*
Bank on  main [!] via 🅒 base 
➜ forge create --rpc-url $GOERLI_URL --private-key $PRIVATE_KEY  --etherscan-api-key $ETHERSCAN_KEY --verify src/Bank.sol:Bank
[⠊] Compiling...
No files changed, compilation skipped
Deployer: 0x750Ea21c1e98CcED0d4557196B6f4a5974CCB6f5
Deployed to: 0x6FD56b2cE823B8bC3b2557a5d8aC02f8b82ab575
Transaction hash: 0xb5d7a6c010af253d2fffe24fbd54fc2d0306b8a2337745c16a6fc95fa6a0048a
Starting contract verification...
Waiting for etherscan to detect contract deployment...
Start verifying contract `0x6FD56b2cE823B8bC3b2557a5d8aC02f8b82ab575` deployed on sepolia

Contract [src/Bank.sol:Bank] "0x6FD56b2cE823B8bC3b2557a5d8aC02f8b82ab575" is already verified. Skipping verification.

Bank on  main [!] via 🅒 base took 19.4s 
*/
