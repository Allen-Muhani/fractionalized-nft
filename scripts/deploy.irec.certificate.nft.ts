import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contract with account:", deployer.address);
  const IRECCertificate = await ethers.getContractFactory("IRECCertificate");
  const irceCert = await IRECCertificate.deploy(deployer);
  await irceCert.waitForDeployment();

  console.log("Contract deployed to:", await irceCert.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
