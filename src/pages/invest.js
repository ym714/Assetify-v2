import { useState } from "react";
import { ethers } from "ethers";
import { getLoanFactoryContract } from "../utils/contract";

const Invest = () => {
  const [amount, setAmount] = useState("");
  const [projectID, setProjectID] = useState("");

  const invest = async () => {
    if (!window.ethereum) return alert("MetaMask をインストールしてください");

    const provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();

    const contract = getLoanFactoryContract(signer);
    const tx = await contract.invest(projectID, ethers.utils.parseEther(amount));
    await tx.wait();

    alert("投資完了！");
  };

  return (
    <div>
      <h1>投資ページ</h1>
      <input type="text" placeholder="プロジェクトID" onChange={(e) => setProjectID(e.target.value)} />
      <input type="text" placeholder="投資額 (ETH)" onChange={(e) => setAmount(e.target.value)} />
      <button onClick={invest}>投資する</button>
    </div>
  );
};

export default Invest;
