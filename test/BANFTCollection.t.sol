//SPDX-License-Identifier: MIT

pragma solidity 0.8.33;

import "forge-std/Test.sol";
import "../src/BANFTCollection.sol";

contract BANFTCollectionTest is Test {
    BANFTCollection nftCollection;
    string name_ = "Blockchain Accelerator NFT";
    string symbol_ = "BANFT";
    uint256 totalSupply_ = 2;
    string baseUri_ = "ipfs://test-cid/";
    address user1 = vm.addr(1);
    address user2 = vm.addr(2);

    event MintNFT(address userAddress_, uint256 tokenId_);

    function setUp() public {
        nftCollection = new BANFTCollection(name_, symbol_, totalSupply_, baseUri_);
    }

    function testDeployedCorrectly() public view {
        assertEq(nftCollection.name(), name_);
        assertEq(nftCollection.symbol(), symbol_);
        assertEq(nftCollection.totalSupply(), totalSupply_);
        assertEq(nftCollection.baseUri(), baseUri_);
        assertEq(nftCollection.currentTokenId(), 0);
    }

    function testMintNFT() public {
        vm.startPrank(user1);
        nftCollection.mint();
        vm.stopPrank();

        assertEq(nftCollection.ownerOf(0), user1);
        assertEq(nftCollection.balanceOf(user1), 1);
        assertEq(nftCollection.currentTokenId(), 1);
    }

    function testMintsConsecutiveTokenIds() public {
        vm.prank(user1);
        nftCollection.mint();
        vm.prank(user2);
        nftCollection.mint();

        assertEq(nftCollection.ownerOf(0), user1);
        assertEq(nftCollection.ownerOf(1), user2);
        assertEq(nftCollection.currentTokenId(), 2);
    }

    function testMintEmitsEventWithMintedTokenId() public {
        vm.expectEmit();
        emit MintNFT(user1, 0);
        vm.prank(user1);
        nftCollection.mint();

        vm.expectEmit();
        emit MintNFT(user2, 1);
        vm.prank(user2);
        nftCollection.mint();
    }

    function testShouldRevertWhenSoldOut() public {
        vm.startPrank(user1);
        nftCollection.mint();
        nftCollection.mint();

        vm.expectRevert("Sold out");
        nftCollection.mint();
        vm.stopPrank();
    }

    function testTokenURI() public {
        vm.prank(user1);
        nftCollection.mint();

        assertEq(nftCollection.tokenURI(0), "ipfs://test-cid/0.json");
    }

    function testTokenURIRevertsForNonexistentToken() public {
        vm.expectRevert();
        nftCollection.tokenURI(0);
    }
}
