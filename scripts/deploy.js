async function main() {
  const EduToken = await ethers.getContractFactory("EduToken");
  const eduToken = await EduToken.deploy();
  await eduToken.deployed();

  console.log("EduToken deployed at:", eduToken.address);
}

main();
