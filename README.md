# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

Make sure to set up your private key in the .env file as follows

PRIVATE_KEY_1=private key 1
PRIVATE_KEY_2=private key 2

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
```

To run test cases:
```shell
npx hardhat test
```


To deploy the certificate/nft on sepolia:
```shell
npx hardhat run scripts/deploy.irec.certificate.nft.ts --network sepolia
```

