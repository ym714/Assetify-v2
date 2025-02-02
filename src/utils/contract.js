import { ethers } from "ethers";
import LoanFactoryABI from "./LoanFactoryABI.json";

const contractAddress = "0xYourContractAddress"; // デプロイ後のアドレスを設定

export const getLoanFactoryContract = (provider) => {
  return new ethers.Contract(contractAddress, LoanFactoryABI, provider);
};
