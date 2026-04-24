// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {AggregatorV3Interface} from "@chainlink/contracts@1.5.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    // use custom library for conversion rate of ETH/USD
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5 * 1e18;
    address private immutable I_OWNER;
    AggregatorV3Interface private sPriceFeed;
    address[] private sSenders;
    mapping(address sender => uint256 amountSent) private sSenderToAmountSent;

    constructor(address priceFeed) {
        I_OWNER = msg.sender;
        sPriceFeed = AggregatorV3Interface(priceFeed);
    }

    function getVersion() public view returns (uint256) {
        return sPriceFeed.version();
    }

    function fund() public payable {
        require(msg.value.getConversionRate(sPriceFeed) >= MINIMUM_USD, "Not enough ETH sent");
        sSenders.push(msg.sender);
        sSenderToAmountSent[msg.sender] += msg.value;
    }

    function withdraw() public ownerOnly {
        uint256 totalSenders = sSenders.length;

        // set transactions to 0
        for (uint256 i = 0; i < totalSenders; i++) {
            address senderAddress = sSenders[i];
            sSenderToAmountSent[senderAddress] = 0;
        }

        // reset sSenders array
        sSenders = new address[](0);

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Withdraw failed");
    }

    // modifiers
    modifier ownerOnly() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        if (msg.sender != I_OWNER) {
            revert FundMe__NotOwner();
        }
    }

    // receive() and fallback()
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // getters
    function getOwner() external view returns (address) {
        return I_OWNER;
    }

    function getSender(uint256 senderIndex) external view returns (address) {
        return sSenders[senderIndex];
    }

    function getSenderToAmountSent(address senderAddress) external view returns (uint256) {
        return sSenderToAmountSent[senderAddress];
    }
}
