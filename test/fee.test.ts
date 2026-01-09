import { expect } from "chai";
import { ethers } from "hardhat";

describe("Constitutional fee schedule (alpha=1)", function () {
  it("fee decreases with global trailing volume and respects floor/ceiling", async function () {
    const [deployer] = await ethers.getSigners();

    const MockOracle = await ethers.getContractFactory("MockGlobalVolumeOracle");
    const oracle = await MockOracle.deploy();
    await oracle.waitForDeployment();

    // fMax=200 bps (2.0%), fMin=25 bps (0.25%), V0=50M
    const V0 = ethers.parseUnits("50000000", 18);

    const FeeOracle = await ethers.getContractFactory("ConstitutionalFeeOracle");
    const feeOracle = await FeeOracle.deploy(200, 25, V0, await oracle.getAddress());
    await feeOracle.waitForDeployment();

    // V = 0 -> f ≈ fMax
    await oracle.setTrailingVolumeE18(0);
    expect(await feeOracle.currentFeeBps()).to.equal(200);

    // V = V0 -> variable part halves => f = fMin + (fMax-fMin)/2
    await oracle.setTrailingVolumeE18(V0);
    const expectedAtV0 = 25 + Math.floor((200 - 25) / 2);
    expect(await feeOracle.currentFeeBps()).to.equal(expectedAtV0);

    // Very large V -> approach floor
    const huge = ethers.parseUnits("1000000000000", 18); // 1T
    await oracle.setTrailingVolumeE18(huge);
    const bps = await feeOracle.currentFeeBps();
    expect(bps).to.be.greaterThanOrEqual(25);
    expect(bps).to.be.lessThan(40); // near floor
  });

  it("DonationIntake takes fee and forwards net", async function () {
    const [deployer, donor, beneficiary, feeSink] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("MockERC20");
    const token = await Token.deploy("Mock USD", "mUSD");
    await token.waitForDeployment();

    const MockOracle = await ethers.getContractFactory("MockGlobalVolumeOracle");
    const oracle = await MockOracle.deploy();
    await oracle.waitForDeployment();

    const V0 = ethers.parseUnits("50000000", 18);
    const FeeOracle = await ethers.getContractFactory("ConstitutionalFeeOracle");
    const feeOracle = await FeeOracle.deploy(200, 25, V0, await oracle.getAddress());
    await feeOracle.waitForDeployment();

    const Intake = await ethers.getContractFactory("DonationIntake");
    const intake = await Intake.deploy(await token.getAddress(), await feeOracle.getAddress(), feeSink.address);
    await intake.waitForDeployment();

    // Set volume so fee is at max (2%)
    await oracle.setTrailingVolumeE18(0);

    // Mint to donor and approve
    const amount = ethers.parseUnits("1000", 18);
    await token.mint(donor.address, amount);
    await token.connect(donor).approve(await intake.getAddress(), amount);

    const feeBps = await feeOracle.currentFeeBps(); // 200
    expect(feeBps).to.equal(200);

    const expectedFee = (amount * BigInt(feeBps)) / 10000n;
    const expectedNet = amount - expectedFee;

    await expect(intake.connect(donor).donate(beneficiary.address, amount))
      .to.emit(intake, "Donation");

    expect(await token.balanceOf(feeSink.address)).to.equal(expectedFee);
    expect(await token.balanceOf(beneficiary.address)).to.equal(expectedNet);
  });
});
