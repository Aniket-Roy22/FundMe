import {ethers} from "ethers";
import {FundMeContractAddress} from "../constants/address";
import abi from "../constants/FundMeABI.json";

export async function withdraw() {
	console.log(`Withdrawing...`);
	if (typeof window.ethereum !== "undefined") {
		const provider = new ethers.BrowserProvider(window.ethereum);
		await provider.send("eth_requestAccounts", []);
		const signer = await provider.getSigner();
		const contract = new ethers.Contract(
			FundMeContractAddress,
			abi,
			signer,
		);
		try {
			console.log("Processing transaction...");
			const transactionResponse = await contract.withdraw();
			await transactionResponse.wait(1);
			console.log("Done!");
		} catch (error) {
			console.log(error);
		}
	} else {
		withdrawButton.innerHTML = "Please install MetaMask";
	}
}
