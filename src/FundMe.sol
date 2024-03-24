// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface } 
    from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{
  AggregatorV3Interface  internal dataFeed;
  using PriceConverter for uint256;
  uint256 public constant minimumUsd = 5 * 1e18;
  address[] private funders;
  address private owner;
  mapping (address funder => uint256 amountFunded) public addressToAountFunded;

   modifier onlyOwner (){
    require(msg.sender == owner,"send is not owner!");
    _;
  }

   constructor(address priceFeed) {
        dataFeed = AggregatorV3Interface (
            priceFeed
        );
        owner = msg.sender;
    }

//从 user获取 funds
function fund() public payable {
    require(msg.value.getConversionRate(dataFeed) >= minimumUsd , "did't sned enough ETH");
    // require(PriceConverter.getConversionRate(msg.value,dataFeed) >= minimumUsd , "did't sned enough ETH");
    funders.push(msg.sender);
    addressToAountFunded[msg.sender] = addressToAountFunded[msg.sender] + msg.value;
}

 receive() external payable{
    fund();
 }

 fallback() external payable{
    fund();
 }

// withDraw funds

//set a minimun funding value in USD



//network: Arbitrum Sepolia
// address: 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165
//ABI: 
function withDrawAll(  ) public  onlyOwner   {

    for (uint256 funderIndex = 0 ; funderIndex < funders.length; funderIndex ++){
        address funder = funders[funderIndex];
        addressToAountFunded[funder] = 0;
    }
    funders = new address[](0); 

    (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
    require(success,"Call failed");

}

function cheaperWithDraw() public onlyOwner {
    uint256 funderLength = funders.length;

     for (uint256 funderIndex = 0 ; funderIndex < funderLength; funderIndex ++){
        address funder = funders[funderIndex];
        addressToAountFunded[funder] = 0;
    }
    
    funders = new address[](0); 
    (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
    require(success,"Call failed");
    
}

function getVersion() public view returns(uint256){

    return dataFeed.version();
    
}

/**
 * uint256 private constant minimumUsd = 5 * 1e18;
  address[] private funders;
  address private owner;
  mapping (address funder => uint256 amountFunded) public addressToAountFunded;
 */
function getAddressToAountFunded(
    address fundingAddress
)external view returns (uint256){
    return addressToAountFunded[fundingAddress];
}

function getFunder (
    uint index
)external view returns(address){
    return funders[index];
}

function getOwner() external view returns(address){
    return owner;
}


    

}