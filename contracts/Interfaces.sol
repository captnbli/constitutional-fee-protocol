// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

interface IGlobalVolumeOracle {
    /// @notice Trailing protocol volume V in 1e18 units (e.g., USD stable equivalent).
    function trailingVolumeE18() external view returns (uint256);
}
