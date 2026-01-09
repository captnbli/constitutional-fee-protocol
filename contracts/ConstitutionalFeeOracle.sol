// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FeeModel.sol";
import "./Interfaces.sol";

/// @notice Immutable-fee oracle wrapper.
/// Holds the constitutional parameters, and computes the fee from a provided global-volume oracle.
contract ConstitutionalFeeOracle {
    uint16 public immutable F_MAX_BPS; // e.g., 200 = 2.00%
    uint16 public immutable F_MIN_BPS; // e.g., 25  = 0.25%
    uint256 public immutable V0_E18;   // e.g., 50_000_000e18 for "half-life" around $50M trailing
    IGlobalVolumeOracle public immutable VOLUME_ORACLE;

    constructor(
        uint16 fMaxBps,
        uint16 fMinBps,
        uint256 v0E18,
        address volumeOracle
    ) {
        require(volumeOracle != address(0), "ORACLE_ZERO");
        require(v0E18 > 0, "V0_ZERO");
        require(fMaxBps >= fMinBps, "BAD_FEE_RANGE");

        F_MAX_BPS = fMaxBps;
        F_MIN_BPS = fMinBps;
        V0_E18 = v0E18;
        VOLUME_ORACLE = IGlobalVolumeOracle(volumeOracle);
    }

    function trailingVolumeE18() public view returns (uint256) {
        return VOLUME_ORACLE.trailingVolumeE18();
    }

    function currentFeeBps() public view returns (uint16) {
        uint256 V = trailingVolumeE18();
        return FeeModel.feeBpsAlpha1(V, V0_E18, F_MAX_BPS, F_MIN_BPS);
    }
}
