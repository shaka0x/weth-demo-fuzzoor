// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Base} from "./Base.sol";
import {Snapshots} from "./Snapshots.sol";
import {PropertiesAsserts} from "./utils/PropertiesHelper.sol";

/// @notice Contains the functions that check the properties (invariants)
abstract contract Properties is Base, Snapshots, PropertiesAsserts {

    // ―――――――――――――――――――― Global properties ―――――――――――――――――――――

    modifier globalProperties() {
        _;
        property_solvencyBalances();
        property_solvencyDeposits();
    }

    function property_solvencyBalances() internal {
        eq(
            address(weth9).balance - ghosts.forcedSendSum,
            sumActorsERC20Balances(address(weth9)),
            "Solvency balances"
        );
    }

    function property_solvencyDeposits() internal {
        eq(
            address(weth9).balance,
            ghosts.depositsSum - ghosts.withdrawalsSum + ghosts.forcedSendSum,
            "Solvency deposits"
        );
    }

    // ――――――――――――――――――― Specific properties ――――――――――――――――――――

    function property_supplyIncreasesOnDeposit(uint256 depositAmount) internal {
        eq(
            stateBefore.totalSupply + depositAmount,
            stateAfter.totalSupply,
            "Supply increases on deposit"
        );
    }
}