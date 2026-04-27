import FundMe from "./components/FundMe";
import {Analytics} from "@vercel/analytics/next";
import "./App.css";

function App()
{
	return (
		<>
			<FundMe />
			<Analytics />
		</>
	);
}

export default App;
