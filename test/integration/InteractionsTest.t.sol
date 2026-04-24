// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundMeDeploy} from "../../script/FundMeDeploy.s.sol";
import {FundingFundMe, WithdrawingFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test
{
	FundMe fundMe;
	address DUMMY_USER = makeAddr("user");
	uint256 constant DUMMY_USER_BALANCE = 10 ether;
	uint256 constant FUND_REVERT_AMOUNT = 0.002 ether; // $4.63
	uint256 constant FUND_SUCCESS_AMOUNT = 0.003 ether; // $ 6.95

	function setUp() external
	{
		FundMeDeploy deploy = new FundMeDeploy();
		fundMe = deploy.run();
		vm.deal(DUMMY_USER, DUMMY_USER_BALANCE);
	}

	function testUserCanFundInteractions() public
	{
		FundingFundMe fundingFundMe = new FundingFundMe();
		fundingFundMe.fundContract(address(fundMe));

		WithdrawingFundMe withdrawingFundMe = new WithdrawingFundMe();
		withdrawingFundMe.withdrawContract(address(fundMe));

		assert(address(fundMe).balance == 0);
	}
}