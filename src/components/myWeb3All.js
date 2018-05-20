// работающая версия взаимодействия с контрактом через инфуру
// годится для использования в мобильных приложениях
import abiOfContract from './abi.js'
const Web3 = require('web3');
const Tx = require('ethereumjs-tx');
//Provider Engine sub-modules
const ethers = require('ethers');
// eslint-disable-next-line
const Wallet = ethers.Wallet;
// eslint-disable-next-line
const Contract = ethers.Contract;
// eslint-disable-next-line
const utils = ethers.utils;
// eslint-disable-next-line
const providers = ethers.providers;


var INFURA_KEY = process.env.REACT_APP_INFURA_KEY
var ACCOUNT_ADDRESS = process.env.REACT_APP_ACCOUNT_ADDRESS
var PRIVATE_KEY = process.env.REACT_APP_PRIVATE_KEY
var CONTRACT_ADDRESS = process.env.REACT_APP_CONTRACT_ADDRESS


const web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/"+INFURA_KEY))
const privateKey = new Buffer(PRIVATE_KEY, 'hex')


// контракт
const myContract = new web3.eth.Contract(abiOfContract, CONTRACT_ADDRESS, {
  from: ACCOUNT_ADDRESS,
  gas: 3000000,
})

// функции из контракта
var name = '_modelName3321'
var email = '_query2132'
var wallet = '_query21122'
var walletType = '_query23322'
var amount = '_query23322'
// eslint-disable-next-line
const addUser = myContract.methods.addUser(name, email, wallet, walletType, amount)
// eslint-disable-next-line
const confirmOwner = myContract.methods.confirmOwner()
// eslint-disable-next-line
const owner = myContract.methods.owner()


var sendInfura = (name,email,wallet,walletType,amount) => {
  let contractFunction = null
  /*
  switch (functionName) {
    case 'addUser':
      contractFunction = addUser
      break;
    case 'confirmOwner':
      contractFunction = confirmOwner
      break;
    default:
      contractFunction = null
  }
  */
  // contractFunction = myContract.methods.confirmOwner()
  contractFunction = myContract.methods.addUser(name, email, wallet, walletType, amount)
  const functionAbi = contractFunction.encodeABI()
  // eslint-disable-next-line
  let estimatedGas
  contractFunction.estimateGas({
    from: ACCOUNT_ADDRESS,
  }).then((gasAmount) => {
    estimatedGas = gasAmount.toString(16)
  })
  // обертка в функцию для получения нонса из количества транзакций
  web3.eth.getTransactionCount(ACCOUNT_ADDRESS).then(txCount => {
    // параметры транзакции
    const txParams = {
      nonce: web3.utils.toHex(txCount),
      gasLimit: web3.utils.toHex(500000), // TODO edit me (use gas estimation maybe?)
      gasPrice: web3.utils.toHex(10e10), // 100 Gwei // TODO edit me (use gas price estimation maybe?)
      to: CONTRACT_ADDRESS,
      data: functionAbi,
      from: ACCOUNT_ADDRESS,
    }
    // транзакция
    const tx = new Tx(txParams)
    // подписание транзакции
    tx.sign(privateKey)
    //
    const serializedTx = tx.serialize()
    //
    // eslint-disable-next-line
    web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex')).
      on('receipt', console.log)
  })

}
export {sendInfura}






//// my wallet
// import wallet
//Note the "0x" appended at the start
//let privateKey = "0x3a1076bf45ab87712ad64ccb3b10217737f7faacbf2872e88fdd9a537d8fe266";


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
