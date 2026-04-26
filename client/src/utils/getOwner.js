import {ethers} from "ethers";
import {FundMeContractAddress} from "../constants/address";
import abi from "../constants/FundMeABI.json";

export async function getOwner() {
	if (typeof window.ethereum != "undefined") {
		const provider = new ethers.BrowserProvider(window.ethereum);

		const contract = new ethers.Contract(
			FundMeContractAddress,
			abi,
			provider,
		);

		try {
			const owner = await contract.getOwner();
			console.log(owner);
			return owner;
		} catch (error) {
			console.log(error);
		}
	} else {
		console.log("Please install Metamask.");
	}
}
