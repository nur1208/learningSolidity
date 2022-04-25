// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
// we don't need save math with solidity > 0.8.0
contract FundMe{
    // safe math library check uint256 for integer overflows
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFund;

    function fund() public payable{ 
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value)  >= minimumUSD, "You need to spend more ETH!");
        addressToAmountFund[msg.sender] += msg.value;
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getDecimals() public view returns(uint8){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.decimals();
    }
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        // answer will be in 8 digit
        // so then add 10 more digit to equle 18.
        // converting to Wei
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    function withdraw() public payable{
        // If you are using version eight (v0.8) of chainlink aggregator interface,
        // you will need to change the code below to
        // payable(msg.sender).transfer(address(this).balance);
        msg.sender.transfer(address(this).balance);

    }


}
