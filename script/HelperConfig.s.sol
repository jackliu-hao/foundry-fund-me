// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelpConfig is Script {

    NetworkConfig public activateNetWorkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITAL_PRICE = 100e8;

    struct  NetworkConfig {
        address priceFeed; //ETH/usd feed address

    }

    constructor (){
        if (block.chainid == 421614){
            activateNetWorkConfig = getArbitrumEthConfig();
        }else {
            activateNetWorkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getArbitrumEthConfig() public pure returns(NetworkConfig memory) {

        NetworkConfig memory ArbitrumConfig = NetworkConfig({
            priceFeed: 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165
        });
        return ArbitrumConfig;

    }

    function getOrCreateAnvilEthConfig() public   returns(NetworkConfig memory) {

        //已经部署过的话，就不用部署了
        if (activateNetWorkConfig.priceFeed != address(0)){
            return activateNetWorkConfig;
        }

        // deploy mocks 
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS,INITAL_PRICE);
        vm.stopBroadcast();

        //return the mock address
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }


}