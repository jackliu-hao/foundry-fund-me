// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {Script,console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelpConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    function run() external returns(FundMe fundMe) {
       HelpConfig helpConfig = new HelpConfig();
       (
            address ethUsdPriceFeed 
        )  = helpConfig.activateNetWorkConfig();
        vm.startBroadcast();
        fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        console.log("contart address is : %s ",address(fundMe));
    }
}