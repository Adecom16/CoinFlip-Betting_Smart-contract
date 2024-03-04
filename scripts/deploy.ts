import { ethers } from "hardhat";

async function main() {


  const CoinFlipFactory = await ethers.deployContract("CoinFlipFactory");

  await CoinFlipFactory.waitForDeployment();

  console.log(
    `CoinFlipFactory with deployed to ${CoinFlipFactory.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
