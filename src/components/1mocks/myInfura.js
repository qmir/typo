
import abiOfContract from './abi.js'
//Provider Engine sub-modules
const ethers = require('ethers');
const Wallet = ethers.Wallet;
const Contract = ethers.Contract;
const utils = ethers.utils;
const providers = ethers.providers;


//// my wallet
// import wallet
//Note the "0x" appended at the start
let privateKey = "0x3a1076bf45ab87712ad64ccb3b10217737f7faacbf2872e88fdd9a537d8fe266";


// create wallet
var newWallet = () => {
  var wallet = Wallet.createRandom();
  console.log('newWallet',wallet);
  return wallet
}
export {newWallet}


//// Network
//let network = "http://192.168.1.1:8545";
//let network = "kovan";
//let network = "ropsten";
let network = "rinkeby";
//let network = "homestead";
let infuraAPIKey = "5HfnvZ04q1A0dl6EbwR2";


//// Provider
//let provider = new providersJsonRpcProvider(network, 'homestead');
let provider = new providers.InfuraProvider(network, infuraAPIKey);
export {provider}
let serverWallet = new Wallet(privateKey, provider);
export {serverWallet}


//// connect to contract
//var addressOfContract = '0x0171234365445c8c39df6b70533b1cf64a51228b' //sokol
var addressOfContract = "0xad47724930425c4524e6a2ffb09b544aad9428c9"; // rinkeby
var contract = new ethers.Contract(addressOfContract, abiOfContract, provider);
export {contract}
