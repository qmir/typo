pragma solidity ^0.4.19;


//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
/// general helpers.
/// `internal` so they get compiled into contracts using them.
library Helpers {
    /// returns whether `array` contains `value`.
    function addressArrayContains(address[] array, address value) internal pure returns (bool) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return true;
            }
        }
        return false;
    }

    // removes an element from array of addresses
    /* NOTE: это дорого? может, просто заменять адрес на нулевой? */
    function removeAddressFromArray(address[] storage array, address addr) internal {
        uint index = array.length;
        for (uint i = 0; i<array.length; i++){
            if (array[i] == addr) {
                index = i;
            }
            if (i >= index) {
                array[i] = array[i+1];
            }
        }
        array.length--;
    }

    // returns the digits of `inputValue` as a string.
    // example: `uintToString(12345678)` returns `"12345678"`
    function uintToString(uint inputValue) internal pure returns (string) {
        // figure out the length of the resulting string
        uint length = 0;
        uint currentValue = inputValue;
        do {
            length++;
            currentValue /= 10;
        } while (currentValue != 0);
        // allocate enough memory
        bytes memory result = new bytes(length);
        // construct the string backwards
        uint i = length - 1;
        currentValue = inputValue;
        do {
            result[i--] = byte(48 + currentValue % 10);
            currentValue /= 10;
        } while (currentValue != 0);
        return string(result);
    }

    // суммируем числа до определенной даты
    function sumToDate(uint[] _uints, uint[] _times, uint _lastTime) pure public returns(uint) {
        uint _sum = 0;
        for (uint i = 0; i < _uints.length; i++) {
            if (_times[i] <= _lastTime) {
                _sum = _sum + _uints[i];
            }
        }
        return _sum;
    }
}



//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}



//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
// Владение
contract owned {
    address public owner;
    address public candidate;

    // функция запускается единожды при создании контракта
    function owned() payable {
        owner = msg.sender;
    }

    // проверка, является ли текущий аккаунт владельцем контракта
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    // изменение владельца контракта
    // с защитой от случайного изменения владельца
    // передача прав на конракт происходдит после вызова двух функций: changeOwner и confirmOwner
    // обозначение нового владельца
    function changeOwner(address _newOwner) onlyOwner public {
        candidate = _newOwner;
    }
    // новый владелец подтвердает свое владение
    function confirmOwner() public {
        require(candidate == msg.sender);
        owner = candidate;
    }

   /*Функция selfdestruct уничтожает контракт и отправляет все средства со счета контракта на адрес, указанный в аргументе*/
   function kill() public onlyOwner {
      selfdestruct(owner);
   }
}



//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
contract ERC20 {
    /// @return total amount of tokens
    function totalSupply() public constant returns (uint256 supply) {}
    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public constant returns (uint256 balance) {}
    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success) {}
    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of wei to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success) {}
    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
    //
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}




//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
/*
TODO:
заменить balances на balanceOf
*/
contract StandardToken is ERC20 {
    // global variables
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;

    // защита от атаки нулевым адресом // NonPayloadAttackable
    // TODO: check what is this
    modifier onlyPayloadSize(uint size) {
       assert(msg.data.length == size + 4);
       _;
    }

    function transfer(address _to, uint256 _value) public
    onlyPayloadSize(2 * 32)
    returns (bool success) {
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) public
    returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        /*
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
        */
        // fixed this, because cannot use this function
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public constant
    returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public
    returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant
    returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

}



//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
/*
TODO:

*/
contract Icareum is StandardToken, owned { // CHANGE THIS. Update the contract name.

    /* Public variables of the token */
    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    string public version = '0.1';  // version of contract
    string public name;                   // имя токена // Token Name
    uint8 public decimals;                // количество нулей, стандатно 18 // How many decimals to show. To be standard complicant keep it 18
    string public symbol;                 // символ токена // An identifier: eg SBX, XPR etc..
    uint256 public unitsOneEthCanBuy;     // количество токенов дается за эфир // How many units of your coin can be bought by 1 ETH?
    uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
    address public fundsWallet;           // Where should the raised ETH go?
    address[] admins; // list of managers, setted by owner
    address[] invitedInvestors; // список приглашенных пользователей


    // This is a constructor function
    // which means the following function name has to match the contract name declared above
    // TODO: should we renew fundsWallet, when we renew owner??
    function Icareum() public {
        balances[msg.sender] = 100000000000000000000000000;               // Give the creator all initial tokens. This is set to 100 000 000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
        totalSupply = 100000000000000000000000000;                        // Update total supply (100 000 000 for example) (CHANGE THIS)
        name = "Icareum";                                   // Set the name for display purposes (CHANGE THIS)
        decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
        symbol = "ICRM";                                             // Set the symbol for display purposes (CHANGE THIS)
        unitsOneEthCanBuy = 10;                                      // Set the price of your token for the ICO (CHANGE THIS)
        fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
    }

    /* TODO: убрать функцию и оставить только ту, что в контракте сейла */
    // функция, которая вызывается в случае, когда кто-либо платит на контракт
    function() internal payable {
        // resume only if address of investor exists in list of invited persons
        require(Helpers.addressArrayContains(invitedInvestors, msg.sender));
        // increase sum of eth (in wei), payed to contract
        totalEthInWei = totalEthInWei + msg.value;
        // amount of tokens, calculated from sended eth
        uint256 amount = msg.value * unitsOneEthCanBuy;
        // check, if wallet, that contains tokens, contains enough tokens
        require(balances[fundsWallet] >= amount);
        // calculate balance of tokens of owner
        balances[fundsWallet] = balances[fundsWallet] - amount;
        // calculate balance of tokens of investor
        balances[msg.sender] = balances[msg.sender] + amount;
        // Broadcast a message to the blockchain
        Transfer(fundsWallet, msg.sender, amount);
        //Transfer ether from investors wallet to fundsWallet
        fundsWallet.transfer(msg.value);
    }

    // Admins
    // check, if user is an admin
    modifier onlyAdmin {
        require(Helpers.addressArrayContains(admins, msg.sender));
        _;
    }
    // owner adds admin to list
    function addAdmin(address _addr) public
    onlyOwner() {
        admins.push(_addr);
    }
    // owner removes admin from list
    function remAdmin(address _addr) public
    onlyOwner() {
        Helpers.removeAddressFromArray(admins, _addr);
    }

    // Investors
    // admin adds invited investor manually
    function addInvestor(address _addr) public
    onlyAdmin() {
        invitedInvestors.push(_addr);
    }
    // admin removes investor manually
    function remInvestor(address _addr) public
    onlyAdmin() {
        Helpers.removeAddressFromArray(invitedInvestors, _addr);
    }



    // TODO: see TokenMarket or other



    // нечто непонятное
    /*
    // Approves and then calls the receiving contract
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
        return true;
    }
    */

}



//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end block, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 TODO: dont forget to add import Icareum
 */
contract Crowdsale {
    using SafeMath for uint256;
    // The token being sold
    Icareum public token;
    // start and end block where investments are allowed (both inclusive)
    uint256 public startBlock;
    uint256 public endBlock;
    // address where funds are collected
    address public wallet;
    // how many token units a buyer gets per wei
    uint256 public rate;
    // amount of raised money in wei
    uint256 public weiRaised;
    /**
    * event for token purchase logging
    * @param purchaser who paid for the tokens
    * @param beneficiary who got the tokens
    * @param value weis paid for purchase
    * @param amount amount of tokens purchased
    */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


    // function of creation
    function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
        require(_startBlock >= block.number);
        require(_endBlock >= _startBlock);
        require(_rate > 0);
        require(_wallet != 0x0);
        // создание контракта токена
        token = createTokenContract();
        // сроки начала и конца сейла
        startBlock = _startBlock;
        endBlock = _endBlock;
        // курс токена к эфиру
        rate = _rate;
        // кошель для сбора средств
        wallet = _wallet;
    }


    // creates the token to be sold.
    // override this method to have crowdsale of a specific mintable token.
    function createTokenContract() internal returns (Icareum) {
        return new Icareum();
    }


    // fallback function can be used to buy tokens
    function () payable {
        buyTokens(msg.sender);
    }


    // low level token purchase function
    function buyTokens(address beneficiary) payable {
        require(beneficiary != 0x0);
        // check some things
        require(validPurchase());
        // sended from investor
        uint256 weiAmount = msg.value;
        // calculate token amount to be created
        uint256 tokens = weiAmount.mul(rate);
        // update state
        weiRaised = weiRaised.add(weiAmount);
        // emiting tokens to investor
        token.mint(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
        // transfer eth from investor to wallet
        forwardFunds();
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal constant returns (bool) {
        uint256 current = block.number;
        // check, if current block is between start and end blocks
        /* TODO: check, if we should change block to time */
        bool withinPeriod = current >= startBlock && current <= endBlock;
        // investor should send non zero amount of tokens
        bool nonZeroPurchase = msg.value != 0;
        // returns true, if both of params are true
        return withinPeriod && nonZeroPurchase;
    }

    // @return true if crowdsale event has ended
    function hasEnded() public constant returns (bool) {
        return block.number > endBlock;
    }


}



//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
/**
 * @title CappedCrowdsale
 * @dev Extension of Crowsdale with a max amount of funds raised
 */
contract CappedCrowdsale is Crowdsale {
  using SafeMath for uint256;
  uint256 public cap;


  function CappedCrowdsale(uint256 _cap) public {
    require(_cap > 0);
    cap = _cap;
  }

  // overriding Crowdsale#validPurchase to add extra cap logic
  // @return true if investors can buy at the moment
  function validPurchase() internal constant returns (bool) {
    bool withinCap = weiRaised.add(msg.value) <= cap;
    return super.validPurchase() && withinCap;
  }

  // overriding Crowdsale#hasEnded to add cap logic
  // @return true if crowdsale event has ended
  function hasEnded() public constant returns (bool) {
    bool capReached = weiRaised >= cap;
    return super.hasEnded() || capReached;
  }

}
