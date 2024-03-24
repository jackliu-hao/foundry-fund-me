// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;
import {AggregatorV3Interface } 
from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
  
    
    //获取 1ETH 值多少 USD 
function getPrice(AggregatorV3Interface   dataFeed) internal  view returns(uint256) {
     // prettier-ignore
        (
            /* uint80 roundID */,
            int answer, // this is price  1USD = answer wei
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return uint256(answer * 1e10); // 增加额外的10个小数
        //3518.520000000000000000
}

function getConversionRate(uint256 ethAmount,AggregatorV3Interface   dataFeed) internal view returns(uint256){
    //获取1eth 是多少 USD , 假设是 3000 
    //实际结果是: 3000 . 00000000000000000  (18个0)
    uint256 ethPrice = getPrice(dataFeed);
    // 1 / 2 = 0
    // 1 ETH  =  1 . 000... (18个0)
    uint256 ethAmoutInUsd = (ethPrice * ethAmount) / 1e18;
    return ethAmoutInUsd;
}


    /**
     * Returns the latest answer.
     */
    // function getChainlinkDataFeedLatestAnswer() public view returns (int) {
    //     // prettier-ignore
    //     (
    //         /* uint80 roundID */,
    //         int answer,
    //         /*uint startedAt*/,
    //         /*uint timeStamp*/,
    //         /*uint80 answeredInRound*/
    //     ) = dataFeed.latestRoundData();
    //     return answer;
    // }

  
}
