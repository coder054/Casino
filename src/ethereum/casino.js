import web3 from "./web3";
import compiledCasino from "./build/Casino.json";

const instance = new web3.eth.Contract(
  JSON.parse(compiledCasino.interface),
  "0xa2602E1c4Bb93333E122fB4a8DC56Fc11db1Ebe2"
  //"0x72a2F49833E8f73431bf32F95272355cb511D773"
);

export default instance;
