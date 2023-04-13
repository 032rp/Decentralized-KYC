async function main() {
    const [deployer] = await ethers.getSigners();
  
    const KYC = await ethers.getContractFactory("KYC");
    const kyc = await KYC.deploy();
    console.log("KYC address:", kyc.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });