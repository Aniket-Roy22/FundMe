import React, {useEffect, useState} from "react";
import "../styles/fundMe.css";
import {connect} from "../utils/connect";
import {getBalance} from "../utils/getBalance";
import {getOwner} from "../utils/getOwner";
import {fund} from "../utils/fund";
import {withdraw} from "../utils/withdraw";

const FundMe = () => {
	const [amount, setAmount] = useState("");
	const [error, setError] = useState("");
	const [balance, setBalance] = useState("0.00");
	const [refreshBalance, setRefreshBalance] = useState(0);
	const [owner, setOwner] = useState("");
	const [walletAddress, setWalletAddress] = useState("");
	const [isConnected, setIsConnected] = useState(false);
	const [isProcessing, setIsProcessing] = useState(false);
	const isOwner = walletAddress && owner && walletAddress === owner;

	useEffect(() => {
		const fetchOwner = async () => {
			const result = await getOwner();
			if (result) {
				setOwner(result);
			}
		};
		fetchOwner();
	}, []);

	useEffect(() => {
		const fetchBalance = async () => {
			const currentBalance = await getBalance();
			setBalance(currentBalance);
		};

		fetchBalance();
	}, [refreshBalance]);

	const handleConnect = async () => {
		const connectedAddress = await connect();
		setWalletAddress(connectedAddress);
		setIsConnected(true);
	};

	const handleFund = async () => {
		try {
			setIsProcessing(true);

			await fund(amount);

			setAmount("");
			setRefreshBalance((prev) => prev + 1);
		} catch (error) {
			console.log(error);
		} finally {
			setIsProcessing(false); // re-enable button
		}
	};

	const handleWithdraw = async () => {
		try {
			setIsProcessing(true);

			await withdraw();

			setRefreshBalance((prev) => prev + 1);
		} catch (error) {
			console.log(error);
		} finally {
			setIsProcessing(false);
		}

		console.log("Withdraw");
	};

	const handleAmountChange = (e) => {
		const value = e.target.value;

		setAmount(value);

		if (value === "") {
			setError("");
			return;
		}

		const num = Number(value);

		if (isNaN(num)) {
			setError("Invalid number");
		} else if (num <= 0) {
			setError("Amount must be greater than 0");
		} else {
			setError("");
		}
	};

	return (
		<div className="fundme-container">
			<div className="fundme-card">
				<div className="fundme-header">
					<h2 className="fundme-title">Fund Me</h2>
					<button
						className={`connect-btn ${isConnected ? "connected" : ""}`}
						onClick={handleConnect}
					>
						{isConnected ? "Connected" : "Connect"}
					</button>
				</div>

				<div className="fundme-balance">
					<span>Balance</span>
					<h3>{balance} ETH</h3>
				</div>

				<div className="divider" />

				<div
					className={`fundme-input-group ${error ? "has-error" : ""}`}
				>
					<div className="fundme-input-wrapper">
						<span className="fundme-eth-badge">
							<svg
								xmlns="http://www.w3.org/2000/svg"
								width="18"
								height="18"
								fill="#ffffff"
								viewBox="0 0 256 256"
							>
								<path d="M220.72,124.29l-88-112a6,6,0,0,0-9.44,0l-88,112a6,6,0,0,0,0,7.42l88,112a6,6,0,0,0,9.44,0l88-112A6,6,0,0,0,220.72,124.29ZM134,33.35l72.56,92.35-72.56,33ZM122,158.68l-72.56-33L122,33.35Zm0,13.18v50.79l-62.08-79Zm12,0,62.08-28.21-62.08,79Z"></path>
							</svg>
						</span>
						<input
							type="text"
							placeholder="Enter amount (ETH)"
							value={amount}
							onChange={handleAmountChange}
							className={`fundme-input ${error ? "input-error" : ""}`}
							disabled={!isConnected}
							step="0.01"
							min="0"
						/>
					</div>
				</div>

				{error && <p className="error-text">{error}</p>}

				<div className="fundme-buttons">
					<button
						className="fundme-btn fund"
						onClick={handleFund}
						disabled={
							!isConnected ||
							!!error ||
							amount === "" ||
							isProcessing
						}
					>
						{isProcessing ? "Processing..." : "Fund"}
					</button>

					<button
						className="fundme-btn withdraw"
						onClick={handleWithdraw}
						disabled={!isOwner || isProcessing}
					>
						{isProcessing ? "Processing..." : "Withdraw"}
					</button>
				</div>

				<div className="fundme-status-bar">
					<div
						className={`fundme-status-dot${isConnected ? " live" : ""}`}
					/>
					<span className="fundme-status-text">
						{isConnected ? walletAddress : "Not connected"}
					</span>
				</div>
			</div>
		</div>
	);
};

export default FundMe;
