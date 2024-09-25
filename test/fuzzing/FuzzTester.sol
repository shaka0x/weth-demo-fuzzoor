// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Handlers} from "./Handlers.sol";

/// @notice Entry point for fuzzing tests
contract FuzzTester is Handlers {
    constructor() payable {
        setup();
        setupActors();
    }
}