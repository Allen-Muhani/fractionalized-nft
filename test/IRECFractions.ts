import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

const one_killo_watt = 1000;

describe("IRECFractions", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployIRECFractionsFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const USDC = await hre.ethers.getContractFactory("USDCMock");
    const usdc = await USDC.deploy(1000000000000000, "USDC", 6, "USDC");
    const IRECFractions = await hre.ethers.getContractFactory("IRECFractions");
    const irceCertFractions = await IRECFractions.deploy(owner, owner, 1);

    await irceCertFractions.setUSDCAddress(await usdc.getAddress());
    return { irceCertFractions, owner, otherAccount, usdc };
  }

  describe("Deployment", function () {
    it("Should set the correct owner", async function () {
      const { irceCertFractions, owner, otherAccount, usdc } =
        await loadFixture(deployIRECFractionsFixture);

      expect(await irceCertFractions.owner()).to.equal(
        owner,
        "Incorrect owner address"
      );
      expect(await irceCertFractions.totalSupply()).to.equal(
        1000000,
        "Total supply is 1,000,000"
      );
      expect(await irceCertFractions.certificateAddress()).to.equal(
        owner,
        "Incorrect certificate address"
      );
      expect(await irceCertFractions.priceInUsdc()).to.equal(
        260,
        "Incorect price"
      );
      expect(await irceCertFractions.certificateId()).to.equal(
        1,
        "incorrect certificate id"
      );

      expect(await usdc.getAddress()).to.equal(
        await irceCertFractions.usdcAddress()
      );
    });
  });

  describe("Buying and Selling", function () {
    it("Buy tokens", async function () {
      const { irceCertFractions, owner, usdc } = await loadFixture(
        deployIRECFractionsFixture
      );

      let fractionsAddress = await irceCertFractions.getAddress();
      await usdc.approve(fractionsAddress, 10000000000000);

      // Buy tokens
      await expect(irceCertFractions.buy(one_killo_watt))
        .to.emit(irceCertFractions, "Buy")
        .withArgs(one_killo_watt, owner);
      expect(await irceCertFractions.balanceOf(owner)).to.equal(one_killo_watt);
      expect(
        await irceCertFractions.balanceOf(await irceCertFractions.getAddress())
      ).to.equal(999_000);

      // Sell tokens
      await expect(irceCertFractions.sell(one_killo_watt))
        .to.emit(irceCertFractions, "Sell")
        .withArgs(one_killo_watt, owner);
      expect(await irceCertFractions.balanceOf(owner)).to.equal(0);
      expect(
        await irceCertFractions.balanceOf(await irceCertFractions.getAddress())
      ).to.equal(1_000_000);
    });
  });
});
