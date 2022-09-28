const { deployments, ethers, network } = require("hardhat");

async function main() {
  const accounts = await ethers.getSigners();
  const deployer = accounts[0];
  await deployments.fixture(["all"]);
  pots = await ethers.getContract("Pots", deployer);

  console.log("Contract Deployed");
  const levelintake = {
    levelId: 1,
    level: {
      theme: 0,
      levelRefId: 0,
      metadataURI: "hello",
    },
  };
  const deployAccount = await pots.connect(deployer);
  await deployAccount.addLevel(levelintake);
  const metadata = await deployAccount.getLevelMetadata(1);
  console.log(metadata);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
