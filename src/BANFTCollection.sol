//SPDX-License-Identifier: MIT

pragma solidity 0.8.33;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract BANFTCollection is ERC721 {
    using Strings for uint256;

    uint256 public currentTokenId;
    uint256 public totalSupply;
    string public baseUri;

    event MintNFT(address userAddress_, uint256 tokenId_);

    constructor(string memory name_, string memory symbol_, uint256 totalSupply_, string memory baseUri_)
        ERC721(name_, symbol_)
    {
        totalSupply = totalSupply_;
        baseUri = baseUri_;
    }

    function mint() external {
        require(currentTokenId < totalSupply, "Sold out");
        _safeMint(msg.sender, currentTokenId);
        currentTokenId++;

        emit MintNFT(msg.sender, currentTokenId--);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString(), ".json") : "";
    }
}
