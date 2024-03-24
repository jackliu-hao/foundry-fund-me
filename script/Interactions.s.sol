// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;


import {Script,console} from "forge-std/Script.sol";


//dev-ops
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

//FundMe
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {

    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address mostRecentlyDeplyed)  public {
        vm.startBroadcast();
        // vm.prank(USER);
        // vm.deal(USER,USER_BALACNE);
        // fundFundMe.fundFundMe(address(fundMe));
        //   address funder = fundMe.getFunder(0);
        //   assertEq(funder,USER);

        FundMe(payable(mostRecentlyDeplyed)).fund{value:SEND_VALUE}(); 

        vm.stopBroadcast();

        console.log("funded foundMe with  %s ",SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeplyed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
         
        fundFundMe(mostRecentlyDeplyed);
         
    }

}

contract WithWrawFundMe is Script {

    uint256 constant SEND_VALUE = 0.01 ether;

    function withdrawFundMe(address mostRecentlyDeplyed)  public {
        vm.startBroadcast();

        FundMe(payable(mostRecentlyDeplyed)).withDrawAll(); 

        vm.stopBroadcast();

        console.log("withdraw foundMe with  %s ",SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeplyed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
          //vm.startBroadcast();
        withdrawFundMe(mostRecentlyDeplyed);
         //vm.stopBroadcast();
    }

}


