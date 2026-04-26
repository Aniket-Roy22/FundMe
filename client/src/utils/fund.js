import {ethers} from "ethers";
import {FundMeContractAddress} from "../constants/address";
import abi from "../constants/FundMeABI.json";

export async function fund(ethAmount) {
	console.log(`Funding with ${ethAmount}...`);
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
			const transactionResponse = await contract.fund({
				value: ethers.parseEther(ethAmount),
			});
			await transactionResponse.wait(1);
		} catch (error) {
			console.log(error);
		}
	} else {
		fundButton.innerHTML = "Please install MetaMask";
	}
}
