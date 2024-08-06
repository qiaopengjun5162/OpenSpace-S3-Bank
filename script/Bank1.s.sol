// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Bank} from "../src/Bank1.sol";

contract Bank1Script is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);
        // 开始广播交易（所有之后的操作都会被视为交易）
        vm.startBroadcast(deployerPrivateKey);

        // 部署 Bank 合约
        Bank bank = new Bank(deployerAddress);

        // 停止广播交易
        vm.stopBroadcast();

        // 输出 Bank 合约地址
        console.log("Bank deployed to:", address(bank));
    }
}

/*
Bank on  main [!?] via 🅒 base 
➜ source .env

Bank on  main [!?] via 🅒 base 
➜ forge script --chain sepolia Bank1Script --rpc-url $SEPOLIA_RPC_URL --account MetaMask --broadcast --verify -vvvv  

[⠊] Compiling...
[⠰] Compiling 5 files with Solc 0.8.25
[⠔] Solc 0.8.25 finished in 1.30s
Compiler run successful!
2024-08-06T16:24:32.874821Z ERROR foundry_compilers_artifacts_solc::sources: error="/Users/qiaopengjun/Code/solidity-code/Bank/lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol": No such file or directory (os error 2)
Error: 
failed to read artifact source file for `/Users/qiaopengjun/Code/solidity-code/Bank/lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol`

Context:
- "/Users/qiaopengjun/Code/solidity-code/Bank/lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol": No such file or directory (os error 2)

Bank on  main [!?] via 🅒 base took 3.6s 
➜ forge build
[⠊] Compiling...
[⠒] Compiling 2 files with Solc 0.8.25
[⠑] Solc 0.8.25 finished in 1.49s
Compiler run successful with warnings:
Warning (2072): Unused local variable.
  --> script/Bank.s.sol:14:9:
   |
14 |         address deployer = msg.sender;
   |         ^^^^^^^^^^^^^^^^


Bank on  main [!?] via 🅒 base 
➜ forge script --chain sepolia Bank1Script --rpc-url $SEPOLIA_RPC_URL --account MetaMask --broadcast --verify -vvvv  

[⠊] Compiling...
No files changed, compilation skipped
Traces:
  [477729] Bank1Script::run()
    ├─ [0] VM::envUint("PRIVATE_KEY") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← [Return] 0x750Ea21c1e98CcED0d4557196B6f4a5974CCB6f5
    ├─ [0] VM::startBroadcast(<pk>)
    │   └─ ← [Return] 
    ├─ [437798] → new Bank@0xC5fb05D72f52553E5C20eEbe590859624C3e1495
    │   └─ ← [Return] 2075 bytes of code
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return] 
    ├─ [0] console::log("Bank deployed to:", Bank: [0xC5fb05D72f52553E5C20eEbe590859624C3e1495]) [staticcall]
    │   └─ ← [Stop] 
    └─ ← [Stop] 


Script ran successfully.

== Logs ==
  Bank deployed to: 0xC5fb05D72f52553E5C20eEbe590859624C3e1495

## Setting up 1 EVM.
==========================
Simulated On-chain Traces:

  [437798] → new Bank@0xC5fb05D72f52553E5C20eEbe590859624C3e1495
    └─ ← [Return] 2075 bytes of code


==========================

Chain 11155111

Estimated gas price: 21.247174149 gwei

Estimated total gas used for script: 683438

Estimated amount required: 0.014521126206044262 ETH

==========================
Enter keystore password:

##### sepolia
✅  [Success]Hash: 0x3cf2d57ff5ecb67b44e997cd28d4e7f4e40efffdb4cbc9e19c781fcdf67633e4
Contract Address: 0xC5fb05D72f52553E5C20eEbe590859624C3e1495
Block: 6449025
Paid: 0.00621716049122244 ETH (525864 gas * 11.822753585 gwei)

✅ Sequence #1 on sepolia | Total Paid: 0.00621716049122244 ETH (525864 gas * avg 11.822753585 gwei)
                                                                                                                    

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
##
Start verification for (1) contracts
Start verifying contract `0xC5fb05D72f52553E5C20eEbe590859624C3e1495` deployed on sepolia

Submitting verification for [src/Bank1.sol:Bank] 0xC5fb05D72f52553E5C20eEbe590859624C3e1495.

Submitting verification for [src/Bank1.sol:Bank] 0xC5fb05D72f52553E5C20eEbe590859624C3e1495.

Submitting verification for [src/Bank1.sol:Bank] 0xC5fb05D72f52553E5C20eEbe590859624C3e1495.
Submitted contract for verification:
        Response: `OK`
        GUID: `ftepxab34yj5tqsg7tfng14iqtjh8r5dfhm6grqrpyisyhy67x`
        URL: https://sepolia.etherscan.io/address/0xc5fb05d72f52553e5c20eebe590859624c3e1495
Contract verification status:
Response: `NOTOK`
Details: `Pending in queue`
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified
All (1) contracts were verified!

Transactions saved to: /Users/qiaopengjun/Code/solidity-code/Bank/broadcast/Bank1.s.sol/11155111/run-latest.json

Sensitive values saved to: /Users/qiaopengjun/Code/solidity-code/Bank/cache/Bank1.s.sol/11155111/run-latest.json


Bank on  main [!?] via 🅒 base took 1m 1.1s 
➜ 
*/
