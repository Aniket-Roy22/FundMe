# FundMe

## About
This is a minimal project allowing users to fund the contract owner with donations. The smart contract accepts ETH as donations, denominated in USD. Donations have a minimal USD value, otherwise they are rejected. The value is priced using a Chainlink price feed, and the smart contract keeps track of donors in case they are to be rewarded in the future.

- [FundMe](#fundme)
	- [About](#about)
	- [Getting Started](#getting-started)
		- [Requirements](#requirements)
		- [Quickstart](#quickstart)
	- [Usage](#usage)
		- [Deploy](#deploy)
		- [Testing](#testing)
			- [Test Coverage](#test-coverage)
	- [Deployment to a testnet or mainnet](#deployment-to-a-testnet-or-mainnet)
		- [Scripts](#scripts)
			- [Withdraw](#withdraw)
		- [Estimate gas](#estimate-gas)
	- [Formatting](#formatting)
	- [Contract Address](#contract-address)

## Getting Started

#### Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
    - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

#### Quickstart

```
git clone https://github.com/Aniket-Roy22/FundMe.git
cd FundMe
make
```

## Usage

#### Deploy

```
forge script script/FundMeDeploy.s.sol
```

#### Testing

```
forge test
```

or

```
// Only run test functions matching the specified regex pattern.

forge test --mt testFunctionName
```

or

```
forge test --fork-url $SEPOLIA_RPC_URL
```

###### Test Coverage

```
forge coverage
```

## Deployment to a testnet or mainnet

1. Setup environment variables

You'll want to set your `SEPOLIA_RPC_URL` and `SEPOLIA_PRIVATE_KEY` as environment variables. You can add them to a `.env` file.

- `PRIVATE_KEY`: The private key of your account (like from [metamask](https://metamask.io/)).
    - You can [learn how to export it here](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).
- `SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with. You can get setup with one for free from [Alchemy](https://alchemy.com/?a=673c802981)

Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

1. Get testnet ETH

Head over to [Google Cloud Web3](https://cloud.google.com/application/web3/faucet/ethereum/sepolia) and get some testnet ETH. You should see the ETH show up in your metamask.

3. Deploy

```
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

#### Scripts

After deploying to a testnet or local net, you can run the scripts.

Using cast deployed locally example:

```
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
```

or

```
forge script script/Interactions.s.sol:FundingFundMe --rpc-url sepolia  --private-key $SEPOLIA_PRIVATE_KEY  --broadcast
forge script script/Interactions.s.sol:WithdrawingFundMe --rpc-url sepolia  --private-key $SEPOLIA_PRIVATE_KEY  --broadcast
```

###### Withdraw

```
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()"  --private-key <PRIVATE_KEY>
```

#### Estimate gas

You can estimate how much gas things cost by running:

```
forge snapshot
```

And you'll see an output file called `.gas-snapshot`

## Formatting

To run code formatting:

```
forge fmt
```

## Contract Address

Address: `0x03CE562BfEE8F88ceEf7a3288dcAc80D6bC6D059`

or

[sepolia.etherscan.io](https://sepolia.etherscan.io/address/0x03CE562BfEE8F88ceEf7a3288dcAc80D6bC6D059)
