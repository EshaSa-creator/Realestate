const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const PlatformToken = await hre.ethers.getContractFactory("PlatformToken");
  const platformToken = await PlatformToken.deploy();

  await platformToken.deployed();

  console.log("PlatformToken deployed to:", platformToken.address);

  // Interact with the deployed contract
  const name = await platformToken.name();
  console.log("Token name:", name);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });