import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

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
};

export default config;
