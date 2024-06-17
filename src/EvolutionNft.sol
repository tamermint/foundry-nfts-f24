// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol"; //for encoding onchain

contract EvolutionNft is ERC721 {
    error EvolutionNft__CantEvolveIfNotOwner();

    uint256 private s_tokenCounter = 0;
    string private s_porcuSvgImageUri;
    string private s_charoSvgImageUri;

    enum Form {
        BASE,
        EVOLVED
    }

    mapping(uint256 => Form) private s_tokenIdToForm;

    constructor(
        string memory porcuSvgImageUri, //pass in the already encoded version so we can save gas by avoiding to encode on chain
        string memory charoSvgImageUri //Uri of the image, NOT the token
    ) ERC721("Pokebot", "PKBT") {
        //pass in the name of collection and the symbol
        //additionally we are passing in the dynamic images which we want to change
        s_tokenCounter = 0;
        s_porcuSvgImageUri = porcuSvgImageUri;
        s_charoSvgImageUri = charoSvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter); //we let anyone mint
        s_tokenIdToForm[s_tokenCounter] = Form.BASE; //default is the base form i.e. porcuparus
        s_tokenCounter++; //increase count by 1
    }

    function flipForm(uint256 tokenId) public {
        //only owner of the token can flip form
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert EvolutionNft__CantEvolveIfNotOwner();
        }
        //flip the form
        if (s_tokenIdToForm[tokenId] == Form.BASE) {
            s_tokenIdToForm[tokenId] = Form.EVOLVED;
        } else {
            s_tokenIdToForm[tokenId] = Form.BASE;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId //will return the tokenUri, based on the mood of the image
    ) public view override returns (string memory) {
        string memory imageUri;

        if (s_tokenIdToForm[tokenId] == Form.BASE) {
            imageUri = s_porcuSvgImageUri;
        } else {
            imageUri = s_charoSvgImageUri;
        }

        return
            string( //convert it back to string
                abi.encodePacked( //again encode with base uri so get the svg+data.. infront of the hash object
                    _baseURI(),
                    Base64.encode( //here we are base64 encoding a bytes object
                        bytes( //here we are converting an abi.encode into bytes object
                            abi.encodePacked( //here we are abi encoding the token uri
                                string.concat(
                                    '{"name": "',
                                    name(),
                                    '", "description": "An NFT that reflects basic and evolved forms of Pokebots.","attributes": [{"trait_type": "form type", "value": 100}], "image": "',
                                    imageUri,
                                    '"}'
                                )
                            )
                        )
                    )
                )
            ); //the result is the the 64PNHH3MDEg.... object that you get as you encode a svg image
    }
}
