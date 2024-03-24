// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;
import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
contract FundMeTest is Test{

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


    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }
    
    //先执行setUp
    function setUp() external {
        // number = 2;
        //  fundMe = new FundMe(0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        //给新用户转一些钱
        vm.deal(USER,USER_BALACNE);
    }

    function testMininumDollarIsFive() public view {
        // console.log(number);
        // assertEq(number,2);
        //这里要加上()  才可以喔
        console.log(fundMe.minimumUsd() );
        assertEq(fundMe.minimumUsd() , 5e18);
    }

    function testOwnerIsMsgSender() public view {
        // us --> test  --deployed--> contract
        // msg.sender = us
        // fundMe.owner = test
         // assertEq(fundMe.owner(),msg.sender);
        assertEq(fundMe.getOwner(),msg.sender);
    }


    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        console.log("version is : %s" , version);
        assertEq(fundMe.getVersion() , 4);
    }

    function testFundMeNotEnough() public {
        vm.expectRevert(); // 期待下一行代码 应该回滚
        //asset(this tx fails)
        fundMe.fund();
    }

     function testFundMeEnough() public funded{
        //vm.expectRevert(); // 期待下一行代码 应该回滚
        //asset(this tx fails)
        // vm.prank(USER); //下一次调用的发起人
        // fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunden =  fundMe.getAddressToAountFunded(USER);
        assertEq(amountFunden,SEND_VALUE);

    }

    function testAddsFunderToArrayOfFunders() public funded{
        // vm.prank(USER);
        // fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder,USER);
    }

    function testOnlyOwnerWithDraw() public funded {
        // vm.prank(USER);
        // fundMe.fund{value: SEND_VALUE}();
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withDrawAll();
    }

    function testOwnerWithDraw() public funded{
        //arrage
        //部署者的开始余额
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        //合约的余额，已经存在捐赠了
        uint256 startingFundMeBalance = address(fundMe).balance;
        console.log("startingOwnerBalance :  %s" , startingOwnerBalance);
        console.log("startingFundMeBalance :  %s" , startingFundMeBalance);
        // console.log("this : %s", address(this).balance);

        //act
        //获取交易中gas的剩余量
        // uint256 gasStart = gasleft();
        //   console.log("gasStart :  %s" , gasStart);
        //设置gas
        // vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withDrawAll();

        //结束的gas
        //  uint256 gasEnd = gasleft();
        //  console.log("gasEnd :  %s" , gasEnd);
        //  uint256 gasUsed =  (gasStart - gasEnd) * tx.gasprice;
        //  console.log("gas used : %s ", gasUsed);
        

        //console.log(fundMe.getOwner().balance);
        
        // //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        console.log("endingOwnerBalance :  %s" , endingOwnerBalance);
        console.log("endingFundMeBalance :  %s" , endingFundMeBalance);

        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance+startingOwnerBalance, endingOwnerBalance);

    }

    function testCheaperWithDraw() public funded{
        //arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex ; i < numberOfFunders ; i++ ){
            //vm.prank
            //vm.deal
            hoax(address(i),SEND_VALUE);
            //fund the fundMe
            fundMe.fund{value:SEND_VALUE}();
        }

          //部署者的开始余额
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        //合约的余额，已经存在捐赠了
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        // vm.prank(fundMe.getOwner());
        vm.startPrank(fundMe.getOwner());
        //这写操作都有 fundMe.getOwner() 操作
        fundMe.cheaperWithDraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance+startingOwnerBalance, endingOwnerBalance);

    }

    function testWithDrawFromMultipleFunders() public funded {
        //arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex ; i < numberOfFunders ; i++ ){
            //vm.prank
            //vm.deal
            hoax(address(i),SEND_VALUE);
            //fund the fundMe
            fundMe.fund{value:SEND_VALUE}();
        }

          //部署者的开始余额
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        //合约的余额，已经存在捐赠了
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        // vm.prank(fundMe.getOwner());
        vm.startPrank(fundMe.getOwner());
        //这写操作都有 fundMe.getOwner() 操作
        fundMe.withDrawAll();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance+startingOwnerBalance, endingOwnerBalance);

    }
    
}