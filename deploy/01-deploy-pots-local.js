const { network, ethers } = require("hardhat");
// const {
//   developmentChains,
//   networkConfig,
// } = require("../helper-hardhat-config");
// const { verify } = require("../utils/verify");
// const { storeNFTs } = require("../utils/uploadToNftStorage");

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;

  const args = [];

  const pot = await deploy("Pots", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });
};

module.exports.tags = ["all", "pots", "main"];
