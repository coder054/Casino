import web3 from "./web3";
import compiledCasino from "./build/Casino.json";

const instance = new web3.eth.Contract(
  JSON.parse(compiledCasino.interface),
  "0xdcAF67eEc986FE9ee5bD013F2c5141071aD0846D"
);

export default instance;
