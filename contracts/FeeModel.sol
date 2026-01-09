// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Fee math library (basis points, BPS) for a constitutional fee schedule.
/// BPS: 10,000 = 100%.
library FeeModel {
    /// @notice Compute fee rate in BPS using alpha=1 power-law decay:
    /// f(V) = fMin + (fMax - fMin) * V0 / (V0 + V)
    /// @param V Trailing global volume in 1e18 units (e.g. USD-equivalent)
    /// @param V0 Scale parameter in 1e18 units (variable part halves near V=V0)
    /// @param fMaxBps Maximum fee in basis points
    /// @param fMinBps Minimum fee (floor) in basis points
    function feeBpsAlpha1(
        uint256 V,
        uint256 V0,
        uint16 fMaxBps,
        uint16 fMinBps
    ) internal pure returns (uint16) {
        require(fMaxBps >= fMinBps, "BAD_FEE_RANGE");
        require(V0 > 0, "V0_ZERO");

        uint256 variableBps = uint256(fMaxBps - fMinBps);
        uint256 denom = V0 + V;

        // variablePart = (fMax-fMin) * V0 / (V0+V)
        uint256 variablePart = (variableBps * V0) / denom;

        uint256 result = uint256(fMinBps) + variablePart;
        if (result > type(uint16).max) result = type(uint16).max;
        return uint16(result);
    }

    /// @notice Apply BPS fee to an amount: fee = amount * bps / 10_000
    function feeAmount(uint256 amount, uint16 bps) internal pure returns (uint256) {
        return (amount * uint256(bps)) / 10_000;
    }
}
