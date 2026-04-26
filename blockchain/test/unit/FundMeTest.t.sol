// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundMeDeploy} from "../../script/FundMeDeploy.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address DUMMY_USER = makeAddr("user");
    uint256 constant DUMMY_USER_BALANCE = 10 ether;
    uint256 constant FUND_REVERT_AMOUNT = 0.002 ether; // $4.63
    uint256 constant FUND_SUCCESS_AMOUNT = 0.003 ether; // $ 6.95

    function setUp() external {
        FundMeDeploy fundMeDeploy = new FundMeDeploy();
        fundMe = fundMeDeploy.run();
        vm.deal(DUMMY_USER, DUMMY_USER_BALANCE);
    }

    function testMinimumUsd() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersion() public view {
        if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        } else {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        }
    }

    function testFundRevertWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund{value: FUND_REVERT_AMOUNT}();
    }

    function _fundSuccess() internal {
        vm.prank(DUMMY_USER);
        fundMe.fund{value: FUND_SUCCESS_AMOUNT}();
    }
    modifier funded() {
        _fundSuccess();
        _;
    }

    function testFundUpdatesSenderData() public funded {
        uint256 amountSent = fundMe.getSenderToAmountSent(DUMMY_USER);
        assertEq(amountSent, FUND_SUCCESS_AMOUNT);
    }

    function testFundAddsSenderToArray() public funded {
        address sender = fundMe.getSender(0);
        assertEq(sender, DUMMY_USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(DUMMY_USER);
        fundMe.withdraw();
    }

    function testWithdrawWhenSingleSender() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        assert(startingOwnerBalance + startingFundMeBalance == fundMe.getOwner().balance);
        assert(address(fundMe).balance == 0);
    }

    // (gas: 563023)
    // (gas: 562082)
    function testWithdrawWhenMultipleSenders() public funded {
        // Arrange
        for (uint160 i = 1; i <= 10; i++) {
            hoax(address(i), DUMMY_USER_BALANCE);
            fundMe.fund{value: FUND_SUCCESS_AMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        assert(startingOwnerBalance + startingFundMeBalance == fundMe.getOwner().balance);
        assert(address(fundMe).balance == 0);
    }
}
