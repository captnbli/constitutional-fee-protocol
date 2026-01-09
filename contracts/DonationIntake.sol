// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Interfaces.sol";
import "./SafeERC20.sol";
import "./FeeModel.sol";
import "./ConstitutionalFeeOracle.sol";

/// @notice Minimal intake contract that applies the constitutional fee and emits an auditable event.
/// This is a demo: real systems would add campaign accounting, payout adapters, dispute handling, etc.
contract DonationIntake {
    using SafeERC20 for IERC20;

    IERC20 public immutable TOKEN;
    ConstitutionalFeeOracle public immutable FEE_ORACLE;
    address public immutable FEE_SINK;

    event Donation(
        address indexed donor,
        address indexed beneficiary,
        uint256 grossAmount,
        uint256 protocolFeeAmount,
        uint256 netAmount,
        uint16  protocolFeeBps,
        uint256 trailingVolumeE18Snapshot
    );

    constructor(address token, address feeOracle, address feeSink) {
        require(token != address(0), "TOKEN_ZERO");
        require(feeOracle != address(0), "ORACLE_ZERO");
        require(feeSink != address(0), "SINK_ZERO");
        TOKEN = IERC20(token);
        FEE_ORACLE = ConstitutionalFeeOracle(feeOracle);
        FEE_SINK = feeSink;
    }

    function donate(address beneficiary, uint256 amount) external {
        require(beneficiary != address(0), "BENEFICIARY_ZERO");
        require(amount > 0, "AMOUNT_ZERO");

        TOKEN.safeTransferFrom(msg.sender, address(this), amount);

        uint256 V = FEE_ORACLE.trailingVolumeE18();
        uint16 bps = FeeModel.feeBpsAlpha1(
            V,
            FEE_ORACLE.V0_E18(),
            FEE_ORACLE.F_MAX_BPS(),
            FEE_ORACLE.F_MIN_BPS()
        );

        uint256 fee = FeeModel.feeAmount(amount, bps);
        uint256 net = amount - fee;

        if (fee > 0) TOKEN.safeTransfer(FEE_SINK, fee);
        TOKEN.safeTransfer(beneficiary, net);

        emit Donation(msg.sender, beneficiary, amount, fee, net, bps, V);
    }
}
