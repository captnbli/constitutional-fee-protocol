import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deployer:", deployer.address);

  const MockOracle = await ethers.getContractFactory("MockGlobalVolumeOracle");
  const oracle = await MockOracle.deploy();
  await oracle.waitForDeployment();

  const V0 = ethers.parseUnits("50000000", 18); // 50M trailing volume scale
  const FeeOracle = await ethers.getContractFactory("ConstitutionalFeeOracle");
  const feeOracle = await FeeOracle.deploy(200, 25, V0, await oracle.getAddress());
  await feeOracle.waitForDeployment();

  console.log("MockGlobalVolumeOracle:", await oracle.getAddress());
  console.log("ConstitutionalFeeOracle:", await feeOracle.getAddress());

  // Note: DonationIntake requires an ERC20 token and a fee sink; for demo we skip.
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
