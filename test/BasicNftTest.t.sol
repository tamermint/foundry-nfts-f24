// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant WOOFIE1 =
        "ipfs://QmaXV1KiqUdSD47JJNbM7yiAdHSDkGqv53wzrJFZSh7VnT?filename=woofie1.json";

    function setUp() external {
        // Deploy the BasicNft contract
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        // Check that the name of the NFT is correct
        string memory expectedName = "Woofie";
        string memory actualName = basicNft.name();
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft(WOOFIE1);

        assert(basicNft.balanceOf(USER) == 1); //assert token balance of USER is 1 i.e. they have 1 token
        assert(
            keccak256(abi.encodePacked(WOOFIE1)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0))) //assert the hash value of 1st token with hash value present at second counter location
        );
    }
}
