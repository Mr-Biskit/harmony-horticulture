const { inputToConfig } = require("@ethereum-waffle/compiler");
const { assert, expect } = require("chai");
const { getNamedAccounts, deployments, ethers, network } = require("hardhat");
const {
  developmentChains,
  networkConfig,
} = require("../../helper-hardhat-config");

!developmentChains.includes(network.name)
  ? describe.skip
  : describe("Pots Unit Tests", function () {
      let pots, deployer;
      const chainId = network.config.chainId;
      const intakeStruct = [
        {
          levelId: 1,
          level: {
            theme: 0,
            levelRefId: 0,
            metadataURI: "hello",
          },
        },
        {
          levelId: 2,
          level: {
            theme: 0,
            levelRefId: 1,
            metadataURI: "how",
          },
        },
        {
          levelId: 3,
          level: {
            theme: 0,
            levelRefId: 2,
            metadataURI: "you",
          },
        },
      ];

      async function addLevelsList() {
        const accounts = await ethers.getSigners();
        const ownerAccount = await pots.connect(accounts[0]);
        const tx = await ownerAccount.addLevelList(intakeStruct);
        await tx.wait();
      }

      beforeEach(async function () {
        deployer = (await getNamedAccounts()).deployer;
        await deployments.fixture(["all"]);
        pots = await ethers.getContract("Pots", deployer);
      });

      describe("Mint Functionality", function () {
        it("Should not be able to mint when notActive", async function () {
          const accounts = await ethers.getSigners();
          const ownerAccount = await pots.connect(accounts[0]);
          expect(ownerAccount.potPlant(1)).to.be.revertedWith("Sale not open");
        });

        it("Should not mint if user wants to mint more than three per wallet", async function () {
          const accounts = await ethers.getSigners();
          const ownerAccount = await pots.connect(accounts[0]);
          const userAccount = await pots.connect(accounts[1]);
          await ownerAccount.setActive(true);
          expect(userAccount.potPlant(3)).to.be.revertedWith(
            "Invalid Mint Amount"
          );
        });

        it("Should set the defaultlevels array to the active levels per tokenId", async function () {
          const accounts = await ethers.getSigners();
          const ownerAccount = await pots.connect(accounts[0]);
          addLevelsList();
          const userAccount = await pots.connect(accounts[1]);
          await ownerAccount.setActive(true);
          await userAccount.potPlant(2);
          const expected = [1, 2, 3];
          const bignumber = [];
          const activeLevels = await ownerAccount.getActiveLevels(1);
          for (i = 0; i < activeLevels.length; i++) {
            int = activeLevels[i].toNumber();
            bignumber.push(int);
          }
          expect(bignumber).to.have.deep.members(expected);
        });
      });

      describe("Level Functionality", function () {
        it("Should be able to add a level intake struct", async function () {
          const accounts = await ethers.getSigners();
          const ownerAccount = await pots.connect(accounts[0]);
          const tx = await ownerAccount.addLevel({
            levelId: 1,
            level: {
              theme: 0,
              levelRefId: 0,
              metadataURI: "hello",
            },
          });
          await tx.wait();
          const meta = await ownerAccount.getLevelMetadata(1);
          assert.equal(meta, "hello");
        });

        it("Should be able to add an entire level intake array", async function () {
          const accounts = await ethers.getSigners();
          const ownerAccount = await pots.connect(accounts[0]);
          const tx = await ownerAccount.addLevelList(intakeStruct);
          await tx.wait();
          const metadata = [];
          for (i = 1; i <= 3; i++) {
            const meta = await ownerAccount.getLevelMetadata(i);
            metadata.push(meta);
          }
          const expectation = ["hello", "how", "you"];
          expect(metadata).to.have.deep.members(expectation);
        });
      });
    });
