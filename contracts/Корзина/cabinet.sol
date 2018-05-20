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




// Владение
contract Ownable {
    address public owner;
    address public candidate;

    // функция запускается единожды при создании контракта
    function Ownable() payable public {
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


contract Main is Ownable {
  using SafeMath for uint256;
  // User object
  struct User {
    uint id;
    string name;
    string email;
    string wallet; // !!! в дальнейшем нужно будет преобразовать в address
    string walletType;
    uint amount;
  }
  User[] public users;
  // events
  event Thanks(uint _amount, bytes _data);


  // добавить юзера
  function addUser(string _name, string _email, string _wallet, string _walletType, uint _amount) onlyOwner public {
    uint _id = users.length;
    users.push(User(_id, _name, _email, _wallet, _walletType, _amount));
  }

  // удалить юзера
  function remUser(uint _id) onlyOwner public {
    delete users[_id];
  }


}
