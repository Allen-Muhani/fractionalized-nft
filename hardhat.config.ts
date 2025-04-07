import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const PRIVATE_KEY_1 = process.env.PRIVATE_KEY_1 ?? "";
const PRIVATE_KEY_2 = process.env.PRIVATE_KEY_2 ?? "";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.28", // Use the version that you are using
    settings: {
      optimizer: {
        enabled: true, // Enable optimization
        runs: 200, // Set the number of optimization runs (higher values reduce contract size further)
      },
    },
  },
  networks: {
    sepolia: {
      url: `https://ethereum-sepolia-rpc.publicnode.com`,
      accounts: [PRIVATE_KEY_1, PRIVATE_KEY_2],
      chainId: 11155111,
    },
  },
};

export default config;
