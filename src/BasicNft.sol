// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter; //keep a counter of tokens
    mapping(uint256 => string) private s_tokenIdtoUri; //to map tokenids to uri

    constructor() ERC721("Woofie", "WFIE") {
        //pass in the name of collection and the symbol
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdtoUri[s_tokenCounter] = tokenUri; //at key 0, put in tokenUri
        _safeMint(msg.sender, s_tokenCounter); //mint token to sender
        s_tokenCounter++; //increse key value for the next token
    }

    function tokenURI(
        uint256 tokenID
    ) public view override returns (string memory) {
        //return the token URI
        return s_tokenIdtoUri[tokenID];
    }
}
