// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Interfaces.sol";

library SafeERC20 {
    function safeTransfer(IERC20 token, address to, uint256 amount) internal {
        bool ok = token.transfer(to, amount);
        require(ok, "TRANSFER_FAILED");
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 amount) internal {
        bool ok = token.transferFrom(from, to, amount);
        require(ok, "TRANSFER_FROM_FAILED");
    }
}
