// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;
import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

import{FundFundMe,WithWrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntrgration is Test {
     // uint256 number = 1;
    FundMe fundMe ;

    //虚拟账户
    address  USER = makeAddr("user");

    //交易的钱数
    uint256 constant SEND_VALUE = 0.1 ether ;
    //新用户的余额

    uint256 constant USER_BALACNE = 10 ether;

    //gas
    uint256 constant GAS_PRICE = 1;
    function setUp() external{
        //  fundMe = new FundMe(0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        //给新用户转一些钱
        vm.deal(USER,USER_BALACNE);
    }

    function testUserCanFundInteractions() public {
        vm.prank(USER);
        FundFundMe fundFundMe = new FundFundMe();
        // vm.prank(USER);
        fundFundMe.fundFundMe(address(fundMe));
       WithWrawFundMe withWrawFundMe =  new WithWrawFundMe();
       withWrawFundMe.withdrawFundMe(address(fundMe));

       assert(address(fundMe).balance == 0);

    }


}