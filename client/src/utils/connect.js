import { ethers } from "ethers";

export async function connect() {
	if (typeof window.ethereum !== "undefined") {
		try {
			const accounts = await ethereum.request({
				method: "eth_requestAccounts",
			});
			// const accounts = await ethereum.request({method: "eth_accounts"});
			// console.log(accounts);
			return ethers.getAddress(accounts[0]);
		} catch (error) {
			console.log(error);
		}
	} else {
		connectButton.innerHTML = "Please install MetaMask";
	}
}