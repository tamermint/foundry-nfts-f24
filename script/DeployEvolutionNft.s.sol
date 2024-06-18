// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {EvolutionNft} from "../src/EvolutionNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployEvolutionNft is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (EvolutionNft) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }
        string memory porcuSvg = vm.readFile("./img/porcuparus.svg");
        string memory charoSvg = vm.readFile("./img/charosaurus.svg");

        vm.startBroadcast(deployerKey);
        EvolutionNft evolutionNft = new EvolutionNft(
            svgToImageUri(porcuSvg),
            svgToImageUri(charoSvg)
        );
        vm.stopBroadcast();
        return evolutionNft;
    }

    //function to put in any svg and get the base64 encoded version
    function svgToImageUri(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseUri = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseUri, svgBase64Encoded));
    }
}
