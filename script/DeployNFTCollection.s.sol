//SPDX-License-Identifier: MIT

pragma solidity 0.8.33;

import {Script} from "forge-std/Script.sol";
import {BANFTCollection} from "../src/BANFTCollection.sol";

contract DeployNFTCollection is Script {

    function run() external returns(BANFTCollection){

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string memory name_ = "Blockchain Accelerator NFT"; 
        string memory symbol_ = "BANFT"; 
        uint256 totalSupply_ = 2;
        string memory baseUri_ = "ipfs://bafybeidorqazjivjlnpvxi7ofqf4qid6qmmochqspmcpl7gwg25eore4ya/";
        BANFTCollection nftCollection = new BANFTCollection(name_, symbol_, totalSupply_, baseUri_);

        vm.stopBroadcast();
        return nftCollection;
    }

}