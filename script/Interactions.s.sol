// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract MintBasicNft is Script {
    string public constant WOOFIE1 =
        "ipfs://QmaXV1KiqUdSD47JJNbM7yiAdHSDkGqv53wzrJFZSh7VnT?filename=woofie1.json";
    string public constant WOOFIE2 =
        "ipfs://QmSwknHRnZ5PHAooGXKof8Mp67s7HCT2ib1NBSuk8uRq5Q?filename=woofie2.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(WOOFIE2); //add more star broadcast, stop broadcast to mint?
        vm.stopBroadcast();
    }
}
