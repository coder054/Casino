import web3 from "./web3";
import compiledCasino from "./build/Casino.json";

const instance = new web3.eth.Contract(
  JSON.parse(compiledCasino.interface),
  "0x9BF7C7D1F401296Ffe2707106A42D21c88aFBF62"
  //"0x72a2F49833E8f73431bf32F95272355cb511D773"
);

export default instance;
