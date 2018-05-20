pragma solidity ^0.4.19;

/*
TODO:
- добавить функцию пресейла и, возможно, сделать так, чтобы токен не создавался, а импортировался
- NonPayloadAttackable проверить, на какие функции должна назначаться эта проверка
- добавить удаление реферрала из списка соответствий аффилиатам
- удалить лишние переменные и все остальное
NOTE:
- если на сервере потребуется разослать токены или что-либо сделать со списком адресов, то нужно иметь в виду, что в списке много нулевых адресов
- реферральная программа работает на стороне веба. приглашенные инвесторы добавляются админом вручную
- сроки сейла не в нормальном времени, а в блоках потому, что так безопасней
- токен выпусскается при деплое контракта продажи токенов
- удаление адреса из массива. это дорого? может, просто заменять адрес на нулевой?
DONE:
- добавить реферральные отчисления и список друзей инвесторов

1994690, 1995669, 1, "0x3c8df154241e6917959bce6ad1d8e3d3d1b13c64"

*/

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
// контракт для того, чтобы узнать номер текущего блока
contract numberOfBlock {
    function f() view returns(uint) {
        return block.number;
    }
}


//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
/// Вспомогательная библиотека
/// `internal`, поэтому библлиотека скомпилируется в использующие ее контракты
library Helpers {
    /// проверка наличия значения в массиве
    function addressArrayContains(address[] array, address value) internal pure returns (bool) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return true;
            }
        }
        return false;
    }

    /*
    // удаляет элемент из массива адресов
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
    */
    // удаляет элемент из массива адресов (заменяет на нулевой)
    function removeAddressFromArray(address[] storage array, address addr) internal {
        for (uint i = 0; i<array.length; i++){
            if (array[i] == addr) {
                array[i] = 0x0;
            }
        }
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
contract Ownable {
    address public owner;
    address public candidate;

    // конструктор контракта
    function Ownable() payable {
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

*/
contract Icareum is ERC20, Ownable {
    // использование библиотеки "безопасная математика" для типа "число"
    using SafeMath for uint256;
    // балансы адресов
    mapping (address => uint256) balances;
    // адрес разрешает другому адресу снять количество токенов
    mapping (address => mapping (address => uint256)) allowed;
    // общее количество токенов в обращении
    uint256 public totalSupply;
    // версия контракта
    string public version = '0.1';
    // имя токена
    string public name;
    // количество нулей, стандатно 18
    uint8 public decimals;
    // символ токена
    string public symbol;
    // количество токенов, которое дается за 1 эфир
    uint256 public unitsOneEthCanBuy;
    // представление в веях денег, собранных на ICO
    uint256 public totalEthInWei;
    // кошель, на котором будут располагаться токены изначально
    address public fundsWallet;
    // факт окончания эмиссии
    bool public mintingFinished = false;
    // событие при доп эмиссии токенов
    event Mint(address indexed to, uint256 amount);
    // событие при окончании эмиссии токенов
    event MintFinished();


    // конструктор контракта
    function Icareum() public {
        // количество токенов, которые пойдут владельцу при деплое контракта
        balances[msg.sender] = SafeMath.mul(20000000,10 ** 18); // 20 000 000
        // общее количество токенов на момент создания
        totalSupply = SafeMath.mul(20000000,10 ** 18); // 20 000 000
        // имя токена
        name = "Icareum";
        // количество нулей
        decimals = 18;
        // символ токена
        symbol = "ICRM";
        // курс токена к эфиру
        unitsOneEthCanBuy = 10;
        // кошелек - владелец средств
        fundsWallet = msg.sender;
    }


    // защита от атаки // NonPayloadAttackable
    modifier onlyPayloadSize(uint size) {
       assert(msg.data.length == size + 4);
       _;
    }


    // передача токенов
    function transfer(address _to, uint256 _value) public
    onlyPayloadSize(2 * 32)
    returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }


    // доверенная передача токенов. передача должна первоначально быть доверена функцией approve
    function transferFrom(address _from, address _to, uint256 _value) public
    onlyPayloadSize(2 * 32)
    returns (bool success) {
        uint256 _allowance = allowed[_from][msg.sender];
        // require (_value <= _allowance); // проверка не требуется, поскольку она есть в функции sub(_allowance, _value)
        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = _allowance.sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }


    // баланс токенов для определенного адреса
    function balanceOf(address _owner) public constant
    returns (uint256 balance) {
        return balances[_owner];
    }


    // доверение определенному лицу _spender тратить определенное количество токенов с адреса пользователя
    function approve(address _spender, uint256 _value) public
    returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }


    // узнать количество токенов, которое может потратить _spender с адреса _owner
    function allowance(address _owner, address _spender) public constant
    returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }


    // проверка возможности выпуска токенов
    modifier canMint() {
      require(!mintingFinished);
      _;
    }


    /**
     * Функция выпуска токенов
     * @dev Function to mint tokens
     * @param _to The address that will recieve the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
      totalSupply = totalSupply.add(_amount);
      balances[_to] = balances[_to].add(_amount);
      Mint(_to, _amount);
      return true;
    }


    /**
     * Остановка выпуска токенов (окончательная и бесповоротная)
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishMinting() onlyOwner returns (bool) {
      mintingFinished = true;
      MintFinished();
      return true;
    }
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
 TODO:
 если токен уже выпущен, то создание токена изменить на его импорт
 */
contract Crowdsale is Ownable {
    // использование библиотеки для чисел
    using SafeMath for uint256;
    // токен
    Icareum public token;
    // максимальное количество выпускаемых токенов
    uint256 totalTokenAmount = SafeMath.mul(100000000,10 ** 18); // 100 000 000
    // блок начала сбора и конца сбора
    uint256 public startBlock;
    uint256 public endBlock;
    // кошель, на который будут поступать средства от продажи токенов
    address public fundWallet;
    // курс токена в отношении к вею
    uint256 public rate;
    // количество полученных средств в веях
    uint256 public tokenSold = 0;
    // количество полученных средств в веях
    uint256 public weiRaised = 0;
    // факт окончания продажи
    bool public isFinalized = false;
    // список админов
    address[] admins;
    // список приглашенных инвестооов
    address[] invitedInvestors;
    // список приглашенных друзей по реферральной программе
    address[] invitedReferrals;
    // соответствие реферралов и аффилиатов
    mapping (address => address) affiliateOfReferral;
    // принадлежность адреса группам
    mapping (string => mapping (address => bool)) internal isInGroup; // имя группы - адрес - состоит/несостоит
    /**
    * событие покупки токенов
    * @param purchaser тот, кто заплатил за токены
    * @param beneficiary тот, кто получил токены
    * @param value сумма в веях, заплаченная за токены
    * @param amount количество переданных токенов
    */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
    // событие окончания краудсейла
    event Finalized();


    // конструктор контракта
    function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _fundWallet) {
        // текущее время должно быть меньше времени старта продажи
        require(_startBlock >= block.number);
        // время конца продажи должно быть больше, чем время начала
        require(_endBlock >= _startBlock);
        // курс токена к эфиру должен быть больше нуля
        require(_rate > 0);
        // кошель для сбора средств не может быть нулевым
        require(_fundWallet != 0x0);
        // создание контракта токена
        token = createTokenContract();
        // сроки начала и конца сейла
        startBlock = _startBlock;
        endBlock = _endBlock;
        // курс токена к эфиру
        rate = _rate;
        // кошель для сбора средств в эфирах
        fundWallet = _fundWallet;
    }


    // создание токена, который будет продаваться
    function createTokenContract() internal returns (Icareum) {
        return new Icareum();
    }


    //// Действующие лица
    // Админы
    // проверка, является ли пользователь админом
    modifier onlyAdmin {
        //require(Helpers.addressArrayContains(admins, msg.sender));
        require(isInGroup["admins"][msg.sender]);
        _;
    }
    // владелец добавляет админа в список
    function addAdmin(address _addr) public
    onlyOwner {
        admins.push(_addr);
        isInGroup["admins"][_addr] = true;
    }
    // владелец удаляет админа из списка
    function remAdmin(address _addr) public
    onlyOwner {
        Helpers.removeAddressFromArray(admins, _addr);
        isInGroup["admins"][_addr] = false;
    }
    // Инвесторы
    // админ добавляет вручную приглашенного инвестора
    function addInvestor(address _addr) public
    onlyAdmin {
        invitedInvestors.push(_addr);
        isInGroup["investors"][_addr] = true;
    }
    // админ удаляет инвестора из списка
    function remInvestor(address _addr) public
    onlyAdmin {
        Helpers.removeAddressFromArray(invitedInvestors, _addr);
        isInGroup["investors"][_addr] = false;
    }
    // Реферралы (приглашенные по реферральной программе)
    // админ добавляет вручную приглашенного реферрала
    function addReferral(address _addrAffiliate, address _addr) public
    onlyAdmin {
        invitedReferrals.push(_addr);
        affiliateOfReferral[_addr] = _addrAffiliate;
        isInGroup["referrals"][_addr] = true;
    }
    // админ удаляет вручную приглашенного реферрала из списка
    function remReferral(address _addr) public
    onlyAdmin {
        Helpers.removeAddressFromArray(invitedReferrals, _addr);
        isInGroup["referrals"][_addr] = false;
    }


    //// Функции управления
    // изменение кошелька с эфирами (фондового)
    function changeFundWallet(address _fundWallet) onlyOwner {
        require(_fundWallet != 0x0);
        fundWallet = _fundWallet;
    }
    // изменение курса токена к эфиру
    function changeRate(uint256 _rate) onlyAdmin {
        require(_rate > 0);
        rate = _rate;
    }
    // выписка токенов с контракта (на баунти и прочие бонусы)
    function withdrawTokens(address _to, uint256 _amount) onlyOwner {
        require(_to != 0x0);
        require(_amount > 0);
        token.mint(_to, _amount);
    }
    // окончание сейла и выписка остатка токенов с контракта
    function finalizeCrowdsale(address _to) onlyOwner {
        require(!isFinalized);
        require(hasEnded());
        require(_to != 0x0);
        uint256 _amount = totalTokenAmount.sub(tokenSold); // остаток токенов
        require(_amount > 0);
        token.mint(_to, _amount);
        token.finishMinting();
        Finalized();
        isFinalized = true;
    }
    // проверка баланса адреса
    function checkBalanceOf(address _addr) view returns (uint) {
        return token.balanceOf(_addr);
    }


    // функция, которая вызывается при поступлении средств на контракт
    // баланс инвестора в веях не нужно проверять, потому, что он не сможет сделать транзакцию, если у него нет средств
    function () payable {
        // !!!!!!!!! разделение на 2 функции покупки - попытка устранить ошибку израсходования газа за транзакцию
        //if (Helpers.addressArrayContains(invitedReferrals, msg.sender)) {
        if (isInGroup["referrals"][msg.sender]) {
            buyTokensByReferral(msg.sender);
        } else if (isInGroup["investors"][msg.sender]) {
            buyTokensByInvestor(msg.sender);
        }
    }


    // функция покупки токенов инвестором
    function buyTokensByInvestor(address beneficiary) payable {
        // адрес получателя не должен быть нулевым
        require(beneficiary != 0x0);
        // продолжить только если адрес пользователя есть в списке приглашенных инвесторов
        //require(Helpers.addressArrayContains(invitedInvestors, beneficiary));
        require(isInGroup["investors"][beneficiary]);
        // проверка возможности продажи токенов
        require(validPurchase());
        // количество присланных денег в веях
        uint256 weiAmount = msg.value;
        // подсчет количества токенов, которые должны быть отосланы в отношении присланной суммы эфиров (по курсу)
        uint256 tokenAmount = weiAmount.mul(rate);
        // увеличить общее количество проданных токенов
        tokenSold.add(tokenAmount);
        // проверка того, не заходит ли запрошенная сумма за максимальное количество токенов
        require(tokenSold <= totalTokenAmount);
        // обновление счетчика присланных денег (капитализации)
        weiRaised = weiRaised.add(weiAmount);
        // перевод токенов с фондового кошелька на кошель инвестора
        token.mint(beneficiary, tokenAmount);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
        // списание средств с кошелька инвестора
        forwardFunds();
    }


    // функция покупки токенов приглашенным реферралом
    function buyTokensByReferral(address beneficiary) payable {
        // адрес получателя не должен быть нулевым
        require(beneficiary != 0x0);
        // продолжить только если адрес пользователя есть в списке приглашенных инвесторов
        //require(Helpers.addressArrayContains(invitedReferrals, beneficiary));
        require(isInGroup["referrals"][beneficiary]);
        // проверка возможности продажи токенов
        require(validPurchase());
        // количество присланных денег в веях
        uint256 weiAmount = msg.value;
        // подсчет количества токенов, которые должны быть отосланы в отношении присланной суммы эфиров (по курсу)
        uint256 tokenAmount = weiAmount.mul(rate);
        // подсчет вознаграждения аффилиата (приглашающего) в токенах (5%)
        uint256 tokenAmountToAffiliate = tokenAmount.mul(SafeMath.div(1,20));
        // увеличить общее количество проданных токенов
        tokenSold.add(tokenAmount);
        // проверка того, не заходит ли запрошенная сумма за максимальное количество токенов
        require(tokenSold <= totalTokenAmount);
        // обновление счетчика присланных денег (капитализации)
        weiRaised = weiRaised.add(weiAmount);
        // перевод токенов с фондового кошелька на кошель инвестора
        token.mint(beneficiary, tokenAmountToAffiliate);
        // перечисление вознаграждения приглашающему
        token.mint(affiliateOfReferral[beneficiary], tokenAmountToAffiliate);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
        // списание средств с кошелька инвестора
        forwardFunds();
    }


    // списание средств с кошелька инвестора
    function forwardFunds() internal {
        fundWallet.transfer(msg.value);
    }


    // @return проверка возможности продажи токенов
    function validPurchase() internal constant returns (bool) {
        // номер текущего блока
        uint256 current = block.number;
        // проверка, находится ли текущий номер блока между номером блока начала сбора средств и номером блока конца сбора
        bool withinPeriod = current >= startBlock && current <= endBlock;
        // инвестор не может прислать нулевое количество эфира
        bool nonZeroPurchase = msg.value != 0;
        // возвращает правду, если обе проверки соблюдены
        return withinPeriod && nonZeroPurchase;
    }


    // @return проверка на окончание продажи токенов
    function hasEnded() public constant returns (bool) {
        return block.number > endBlock;
    }

}
