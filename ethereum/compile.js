const path = require("path");
const solc = require("solc");
const fs = require("fs-extra");

const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath); // delete build folder and everything inside

const casinoPath = path.resolve(__dirname, "contracts", "Casino.sol");

const source = fs.readFileSync(casinoPath, "utf8");

const output = solc.compile(source, 1).contracts; // la mot object, voi key la ten cua contract

fs.ensureDirSync(buildPath); // check if folder exist, if not, create directory

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.replace(":", "") + ".json"),
    output[contract]
  );
}
