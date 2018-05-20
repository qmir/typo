pragma solidity ^0.4.19;
//pragma experimental abiencoderv2;

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



// ERC20Interface
contract ERC20 {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint value) public returns (bool success);
    function approve(address spender, uint value) public returns (bool success);
    function transferFrom(address from, address to, uint value) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed tokenOwner, address indexed spender, uint value);
}

/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

  function balanceOf(address _owner) public view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function exists(uint256 _tokenId) public view returns (bool _exists);

  function approve(address _to, uint256 _tokenId) public;
  function getApproved(uint256 _tokenId) public view returns (address _operator);

  function setApprovalForAll(address _operator, bool _approved) public;
  function isApprovedForAll(address _owner, address _operator) public view returns (bool);

  function transferFrom(address _from, address _to, uint256 _tokenId) public;
  function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes _data
  )
    public;
}


// Владение
contract owned {
    address public owner;
    address public candidate;

    // функция запускается единожды при создании контракта
    function owned() payable public {
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
}


contract Main is owned {
  using SafeMath for uint256;
  // tokens on the contract
  address[] public tokens;
  // amount of ether, sended to contract by users
  uint sendedAmount;
  // data, sended from user with a transaction (see metamask "send")
  bytes msgData;
  // amount of each token on the contract
  mapping (address => uint) amountOfToken;
  // course of each token pair
  mapping (address => uint) courseOfTokenPair;
  // pair object
  struct Pair {
    string name;
    address[] pair;
    uint course;
  }
  // events
  event Thanks(uint _amount, bytes _data);
  event Deposit(address indexed token, address indexed owner, uint amount);
  event Withdraw(address indexed token, address indexed owner, uint amount);

  // fallback function
  // it calls when user sends ether to this contract
  function() external payable {
    // amount of sended money from user
    sendedAmount = msg.value;
    // data, sended from user with a transaction (see metamask "send")
    msgData = msg.data;
    // event to thank users, that sended donates, and to show their words from data field
    Thanks(sendedAmount, msgData);
  }


/*
  // renew course of all existing tokens manually
  // data goes from dapp thru a foreign exchange
  function renewCourse(Pair[] pairs)
    public
    view
    onlyOwner
    returns(Pair[])
  {
    return pairs;
  }
  */



  // amount of erc20 to sell
  // amount of erc20 to buy
  function exchange(ERC20 _tokenToSell, ERC20 _tokenToBuy, uint _amountToSell)
    public
    payable
    returns(bool)
  {
    // calc amounts
    uint _course = SafeMath.div(5,100);
    uint _amountToBuy = SafeMath.mul(_amountToSell,_course);
    // check balances
    require(_amountToSell>0);
    require(_tokenToSell.balanceOf(msg.sender)>=_amountToSell);
    require(_tokenToBuy.balanceOf(this)>=_amountToBuy);
    // exchange
    // sender lets exchange to get his tokens
    //erc20tokenToSell.approve(msg.sender, _amountToSell);
    // exchange lets sender to get its tokens
    _tokenToBuy.approve(msg.sender, _amountToBuy);
    // sender transfers
    _tokenToSell.transferFrom(msg.sender, this, _amountToSell);
    _tokenToBuy.transferFrom(this, msg.sender, _amountToBuy);
    // result
    return true;
  }

  ////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////
  // Erc20

  // send tokens to another address
  function depositErc20Token(address _token, uint _amount)
    public
    //onlyOwner
    //returns(bool)
  {
    // check balances
    //require(_token.balanceOf(this)>=_amount);
    // let contract to transfer tokens from user account
    ERC20(_token).approve(this, _amount);
    //event Approval(this, msg.sender, _amount);
    ERC20(_token).transferFrom(msg.sender, this, _amount);
    //ERC20(_token).transfer(this, _amount);
    //return true;
  }


  // send tokens to another address
  function withdrawErc20Token(address _token, uint _amount)
    public
    //onlyOwner
    //returns(bool)
  {
    // check balances
    //require(_token.balanceOf(msg.sender)>=_amount);
    //event Approval(this, msg.sender, _amount);
    ERC20(_token).transfer(msg.sender, _amount);
    //event Transfer(this, msg.sender, _amount);
    Withdraw(_token, msg.sender, _amount);
    //return true;
  }


  // check balances
  function balanceErc20Token(address _token)
    public
    view
    returns(uint)
  {
    return ERC20(_token).balanceOf(this);
  }


  ////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////
  // Erc721

  // send tokens to contract
  function depositErc721Token(address _token, uint _tokenId)
    public
  {
    // let contract to transfer tokens from user account
    ERC721(_token).approve(this, _tokenId);
    ERC721(_token).transferFrom(msg.sender, this, _tokenId);
  }


  // send tokens to another address
  function withdrawErc721Token(address _token, uint _tokenId)
    public
    //onlyOwner
    //returns(bool)
  {
    ERC721(_token).approve(msg.sender, _tokenId);
    ERC721(_token).transferFrom(this, msg.sender, _tokenId);
  }


  // check balances
  function balanceErc721Token(address _token)
    public
    view
    returns(uint)
  {
    return ERC721(_token).balanceOf(this);
  }


}
