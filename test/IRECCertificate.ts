import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("IRECCertificate", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployIRECCertificateFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const IRECCertificate = await hre.ethers.getContractFactory(
      "IRECCertificate"
    );
    const irceCert = await IRECCertificate.deploy(owner);

    return { irceCert, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set the correct owner", async function () {
      const { irceCert, owner, otherAccount } = await loadFixture(
        deployIRECCertificateFixture
      );

      expect(await irceCert.owner()).to.equal(owner);
    });
  });

  describe("Minting", function () {
    it("Perform safe mint", async function () {
      const { irceCert, owner, otherAccount } = await loadFixture(
        deployIRECCertificateFixture
      );

      await expect(irceCert.safeMint(otherAccount, "TestDetails", "TestURI"))
        .to.emit(irceCert, "CertificateMinted")
        .withArgs(0, "TestDetails", "TestURI");
      expect(await irceCert.getCertificateDetails(0)).to.equal("TestDetails");
    });

    it("Fractionalize minted token", async function () {
      const { irceCert, owner, otherAccount } = await loadFixture(
        deployIRECCertificateFixture
      );

      await expect(irceCert.safeMint(otherAccount, "TestDetails", "TestURI"))
        .to.emit(irceCert, "CertificateMinted")
        .withArgs(0, "TestDetails", "TestURI");
      expect(await irceCert.getCertificateDetails(0)).to.equal("TestDetails");

      await expect(irceCert.fractionalize(0)).to.emit(
        irceCert,
        "CertificateFractionalized"
      );

      expect(await irceCert.getFractionalERc20(0)).not.equals("");
    });
  });
});
