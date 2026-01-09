// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Interfaces.sol";

/// @notice TESTING-ONLY volume oracle.
/// In production, trailing volume must be computed according to a clearly defined constitution.
/// This mock is mutable so tests can simulate adoption levels.
contract MockGlobalVolumeOracle is IGlobalVolumeOracle {
    uint256 private _v;

    event VolumeUpdated(uint256 newTrailingVolumeE18);

    function setTrailingVolumeE18(uint256 v) external {
        _v = v;
        emit VolumeUpdated(v);
    }

    function trailingVolumeE18() external view returns (uint256) {
        return _v;
    }
}
