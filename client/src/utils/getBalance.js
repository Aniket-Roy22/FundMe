import { ethers } from "ethers";
import { FundMeContractAddress } from "../constants/address";

export async function getBalance() {
	if (typeof window.ethereum !== "undefined") {
	  const provider = new ethers.BrowserProvider(window.ethereum)
	  try {
		const balance = await provider.getBalance(FundMeContractAddress);
		console.log(ethers.formatEther(balance))
		return ethers.formatEther(balance);
	  } catch (error) {
		console.log(error)
	  }
	} else {
	  balanceButton.innerHTML = "Please install MetaMask"
	}
}