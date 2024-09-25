// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Base.sol";
import {Properties} from "./Properties.sol";

/// @notice Handles the interaction with the contracts under test
abstract contract Handlers is Properties {

	// ―――――――――――――――――――――――――― WETH9 ―――――――――――――――――――――――――――

	function weth9_deposit() public payable useActor globalProperties {
		uint256 msgValue = clampLte(msg.value, actor.balance());

        snapshotBefore();

		vm.prank(address(actor));
		weth9.deposit{value: msgValue}();

        snapshotAfter();

        ghosts.depositsSum += msgValue;

        property_supplyIncreasesOnDeposit(msgValue);
	}

	function weth9_withdraw(uint256 wad) public useActor globalProperties {
        wad = clampLte(wad, weth9.balanceOf(address(actor)));

		vm.prank(address(actor));
		weth9.withdraw(wad);

        ghosts.withdrawalsSum += wad;
	}

	function weth9_approve(address guy, uint256 wad) public useActor globalProperties {
        guy = toActorAddressNotCurrent(guy);
        wad = clampLte(wad, weth9.balanceOf(address(actor)));

		vm.prank(address(actor));
		weth9.approve(guy, wad);
	}

	function weth9_transfer(address dst, uint256 wad) public useActor globalProperties {
        dst = toActorAddressNotCurrent(dst);
        wad = clampLte(wad, weth9.balanceOf(address(actor)));

		vm.prank(address(actor));
		weth9.transfer(dst, wad);
	}

	function weth9_transferFrom(address src, address dst, uint256 wad) public useActor globalProperties {
		src = toActorAddress(src);
        dst = toActorAddressNotCurrent(dst);
        wad = clampLte(wad, weth9.balanceOf(src));
        wad = clampLte(wad, weth9.allowance(src, address(actor)));
        
        vm.prank(address(actor));
		weth9.transferFrom(src, dst, wad);
	}

	function weth9_fallback() public payable useActor globalProperties {
		uint256 msgValue = clampLte(msg.value, actor.balance());

		vm.prank(address(actor));
		(bool success,) = address(weth9).call{value: msgValue}("");

		t(success, "fallback call failed");

        ghosts.depositsSum += msgValue;
	}

	function weth9_forceSendETH(uint256 amount) public useActor globalProperties {
		amount = clampLte(amount, actor.balance());

		actor.forceSendETH(address(weth9), amount);

        ghosts.forcedSendSum += amount;
	}
}