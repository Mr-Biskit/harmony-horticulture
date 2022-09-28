const networkConfig = {
  80001: {
    name: "mumbai",
    vrfCoordinatorV2: "0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed",
    entranceFee: "100000000000000000",
    gasLane:
      "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc",
    subscriptionId: "1686",
    callbackGasLimit: "500000",
    interval: "30",
    mintFee: "0",
  },
  31337: {
    name: "hardhat",
    ethUsdPriceFeed: "0x9326BFA02ADD2366b30bacB125260Af641031331",
    gasLane:
      "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc",
    subscriptionId: "588",
    callbackGasLimit: "500000",
    interval: "30",
    mintFee: "0",
  },
};

const developmentChains = ["hardhat", "localhost"];

module.exports = {
  networkConfig,
  developmentChains,
};
