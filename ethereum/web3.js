import Web3 from "web3";

let web3;

if (typeof window !== "undefined" && typeof window.web3 !== "undefined") {
  // we are in the browser and meta mask is running
  web3 = new Web3(window.web3.currentProvider);
} else {
  // we are onserver or not have meta mask running

  const provider = new Web3.providers.HttpProvider(
    "https://rinkeby.infura.io/orDImgKRzwNrVCDrAk5Q"
  );

  web3 = new Web3(provider);
}

export default web3;
