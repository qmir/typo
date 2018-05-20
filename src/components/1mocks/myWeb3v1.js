// работающая версия взаимодействия с контрактом через инфуру
// годится для использования в мобильных приложениях
import abiOfContract from './abi.js'
const Web3 = require('web3');
const Tx = require('ethereumjs-tx');


var ACCOUNT_ADDRESS = '0xfe0D3969f978b7a8892b94C66BEF73d8B3490243'
var PRIVATE_KEY = '6e3407502f94382c12311904fb407e7bbc200e1a82aa9baeedb78fad53f64ec1'
var CONTRACT_ADDRESS = '0xad47724930425c4524e6a2ffb09b544aad9428c9'


const web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/5HfnvZ04q1A0dl6EbwR2"))
const privateKey = new Buffer(PRIVATE_KEY, 'hex')
//const contract = web3.eth.contract(abiOfContract).at(CONTRACT_ADDRESS)

const contract = new web3.eth.Contract(abiOfContract, CONTRACT_ADDRESS, {
  from: ACCOUNT_ADDRESS,
  gas: 3000000,
})



var _modelName = '_modelName333'
var _query = '_query222'
const opts = {
  //from: serverWallet,
  gasLimit: 1000000,
  //gasPrice: 10,
  //value: web3.toWei(0, 'ether')
}
const functionAbi = contract.methods.addModelList(_modelName, _query).encodeABI()
let estimatedGas
contract.methods.addModelList(_modelName, _query).estimateGas({
  from: ACCOUNT_ADDRESS,
}).then((gasAmount) => {
  estimatedGas = gasAmount.toString(16)
})




var sendInfura = () => {
  web3.eth.getTransactionCount(ACCOUNT_ADDRESS).then(txCount => {
    const txParams = {
      nonce: web3.utils.toHex(txCount),
      gasLimit: web3.utils.toHex(250000), // TODO edit me (use gas estimation maybe?)
      gasPrice: web3.utils.toHex(10e8), // 1 Gwei // TODO edit me (use gas price estimation maybe?)
      to: CONTRACT_ADDRESS,
      data: functionAbi,
      from: ACCOUNT_ADDRESS,
    }
    const tx = new Tx(txParams)
    tx.sign(privateKey)
    const serializedTx = tx.serialize()
    //
    web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex')).
      on('receipt', console.log)
  })

}
export {sendInfura}
