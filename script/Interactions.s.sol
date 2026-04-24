// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundingFundMe is Script {
    uint256 private constant SEND_VALUE = 0.01 ether;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundContract(mostRecentlyDeployed);
    }

    function fundContract(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }
}

contract WithdrawingFundMe is Script {
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawContract(mostRecentlyDeployed);
    }

    function withdrawContract(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }
}
