// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {EvolutionNft} from "../src/EvolutionNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployEvolutionNft is Script {
    string public constant porcuSvgUri = "lmn";

    string public constant charoSvgUri = "opq";

    function run() external returns (EvolutionNft) {
        vm.startBroadcast();
        EvolutionNft evolutionNft = new EvolutionNft(porcuSvgUri, charoSvgUri);
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
