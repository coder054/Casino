Install:

- npm install --global --production windows-build-tools
- npm install
- npm run start

This repo already include the compiled code of contract file. If you want to re-compile run:

- node .\src\ethereum\compile.js
  To re-deploy contract run
- node .\src\ethereum\deploy.js
  Then copy the address that the contract is deployed to, finally paste it into src/ethereum/casino.js
