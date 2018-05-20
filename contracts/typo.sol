pragma solidity ^0.4.19;
//pragma experimental abiencoderv2;


/*

TODO:
- сделать проще (роли)

DONE:
-

NOTE:
-

*/

//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////

// контракт для того, чтобы можно было проверять наличие пользователя в нескольких группах
contract IfUserIsInGroup {
    function IfUserIsInGroup() public {}

    // факт того, что адрес состоит в группе
    mapping (string => mapping (address => bool)) internal isInGroup; // имя группы => адрес => состоит/несостоит

    // добавить в группу
    function addToGroup(string _group, address _addr) public returns(uint) {
        isInGroup[_group][_addr] = true;
    }

    // проверка того, что адрес состоит во всех группах
    modifier isInAllOfGroups(string[] _groups) {
        uint _sum = 0;
        for (uint i = 0; i<_groups.length; i++){
            if (isInGroup[_groups[i]][msg.sender]) {
                _sum = _sum + 1;
            }
        }
        require(_sum == _groups.length);
        _;
    }

    // проверка того, что адрес состоит в одной из групп
    modifier isInOneOfGroups(string[] _groups) {
        uint _sum = 0;
        for (uint i = 0; i<_groups.length; i++){
            if (isInGroup[_groups[i]][msg.sender]) {
                _sum = _sum + 1;
            }
        }
        require(_sum > 0);
        _;
    }

    // список групп для сравнения
    string[] grs = ["invs","refs"];
    // пример использования модификатора
    function ifInOneOfGroups() view public
    isInOneOfGroups(grs)
    returns(bool) {
        return true;
    }
    // пример использования модификатора
    function ifInAllOfGroups() view public
    isInAllOfGroups(grs)
    returns(bool) {
        return true;
    }
}

//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
/*
*** Типография на эфире ***

Заявка на печать
  Тип носителя (книга, газета, йогурт)
  Формат (площадь листа)
  Количество листов в одном экземпляре
  Тираж
Прием заявки
  Проверка наличия материалов на складе
    Расчет требуемых материалов
      На каждый тип носителя - разная конфигурация материалов
    Наличие на складе
  Проверка очереди печати и вывод времени ожидания
    Подсчет количества времени на выполнение всего заказа
    Суммирование со временем очереди и разница с текущим временем
      В случае, если удаляется заказ из середины очереди, время должно пересчитываться для всей очереди
Оформление заказа дизайнером
  Работа дизайнера
  Представление работы
  Решение покупателя о печати заказа
Печать заказа
  Поступление заказа на печать
  Перемещение материалов со склада
  Печать
Заказ распечатан
*/

contract Typo is IfUserIsInGroup {
  // User object
  struct Worker {
    string name;
    string role;
    address wallet;
    string walletKey;
  }
  Worker[] public Workers;
  // Order object
  struct Order {
    string status;
    string nameOfClient;
    OrderType typ;
    uint areaOfPage;
    uint countOfPages;
    uint countOfAll;
  }
  Order[] public Orders;
  // OrderType object
  struct OrderType {
    string name;
    string typ;
    uint timePerPage;
  }
  OrderType[] public OrderTypes;
  // Material object
  struct Material {
    string name;
    uint count;
    string units;
  }
  Material[] public Materials;
  // Queue object
  struct Queue {
    uint idOfOrder;
    uint time;
  }
  Queue[] public Queues;
  // mappings
  // факт того, что адрес состоит в группе
  mapping (string => mapping (address => bool)) internal isInRole; // имя группы => адрес => состоит/несостоит
  //
  mapping (string => string) someMapping;
  // events
  event Thanks(uint _amount, bytes _data);
  // конструктор
  function Typo() public {}


  //////////////////////////////////////////////
  // Проверки
  //////////////////////////////////////////////


  // проверка, состоит ли пользователь в числе группы сотрудников
  modifier onlyInRole(string _role) {
      require(isInRole[_role][msg.sender]);
      _;
  }


  //////////////////////////////////////////////
  // Администрирование
  //////////////////////////////////////////////


  // Кадровый отдел
  // группы допущенных к редактированию лиц
  string[] grsw = ["владелец","кадровик"];
  // добавить сотрудника
  function addWorker(string _name, string _role, address _wallet, string _walletKey) isInOneOfGroups(grsw) public {
    Workers.push(Worker(_name, _role, _wallet, _walletKey));
    isInRole[_role][_wallet] = true;
  }
  // удалить сотрудника
  function remWorker(uint _id) isInOneOfGroups(grsw) public {
    delete Workers[_id];
  }
  // добавить сотрудника на должность или снять
  function addOrRemFromRole(string _role, address _wallet, bool _bool) isInOneOfGroups(grsw) public {
      isInRole[_role][_wallet] = _bool;
  }


  // Склад (Store)
  // группы допущенных к редактированию лиц
  string[] grss = ["владелец","кладовщик"];
  // добавить материал на склад
  function addMaterial(string _name, uint _count, string _units) isInOneOfGroups(grss) public {
    Materials.push(Material(_name, _count, _units));
  }
  // удалить материал
  function remMaterial(uint _id) isInOneOfGroups(grss) public {
    delete Materials[_id];
  }
  // изменить объем материала
  function minusMaterialCount(uint _id, uint _count) isInOneOfGroups(grss) public {
    Materials[_id].count = Materials[_id].count - _count;
  }
  function plusMaterialCount(uint _id, uint _count) isInOneOfGroups(grss) public {
    Materials[_id].count = Materials[_id].count + _count;
  }
  // проверка наличия материала на складе
  function ifMaterialExists(uint _id) isInOneOfGroups(grss) public {
    delete Workers[_id];
  }
  // может добавить вывод списка всех материалов?



  // Заявка на печать от клиента
  // группы допущенных к редактированию лиц
  string[] grso = ["владелец","менеджер","клиент"];
  // Добавить тип заказа
  function addOrderType(
    string _name,
    string _typ,
    uint _areaOfPage,
    uint _timePerPage
  ) isInOneOfGroups(grsq) public {
    OrderTypes.push(OrderType(
      _name,
      _typ,
      _timePerPage
    ));
  }
  // удалить тип заказа
  function remOrderType(uint _id) isInOneOfGroups(grso) public {
    delete OrderTypes[_id];
  }
  // изменить тип заказа
  function changeOrderType(
    uint _id,
    string _name,
    string _typ,
    uint _areaOfPage,
    uint _timePerPage
  ) isInOneOfGroups(grso) public {
    OrderTypes[_id] = OrderType(
      _name,
      _typ,
      _timePerPage
    );
  }
  // добавить заявку
  function addOrder(
    string _status,
    string _nameOfClient,
    OrderType _typ,
    uint _areaOfPage,
    uint _countOfPages,
    uint _countOfAll
  ) isInOneOfGroups(grso) public {
    Orders.push(Order(
       _status,
       _nameOfClient,
       _typ,
       _areaOfPage,
       _countOfPages,
       _countOfAll
    ));
  }
  // изменить статус заявки
  function changeOrderStatus(uint _id, string _status) isInOneOfGroups(grso) public {
    Orders[_id].status = _status;
  }
  // удалить заявку
  function remOrder(uint _id) isInOneOfGroups(grso) public {
    delete Orders[_id];
  }
  // изменить очередность заказов
  function orderToOrder(uint _id1, uint _id2) isInOneOfGroups(grso) public {
    Orders.push(Orders[_id1]);
    Orders[_id1] = Orders[_id2];
    Orders[_id2] = Orders[Orders.length - 1];
    delete Orders[Orders.length - 1];
  }


  // Отдел печати
  // группы допущенных к редактированию лиц
  string[] grsq = ["владелец","менеджер"];
  // Добавить в очередь печати еще один элемент
  function addQueue(uint _idOfOrder, uint _time) isInOneOfGroups(grsq) public {
    Queues.push(Queue(
      _idOfOrder,
      _time
    ));
  }
  // подсчитать общее время
  function calcQueueTimeAll() isInOneOfGroups(grsq) public view returns(uint) {
    uint allTime = 0;
    for (uint i = 0; i<Queues.length; i++){
      allTime = allTime + Queues[i].time;
    }
    return allTime;
  }
  // подсчитать время на текущий заказ с учетом его типа и его количества
  function calcOrderTime(uint _id) isInOneOfGroups(grsq) public view returns(uint){
    uint time = Orders[_id].areaOfPage * Orders[_id].countOfPages * Orders[_id].typ.timePerPage;
    return time;
  }
  // подсчитать время готовности текущего заказа с учетом очереди
  //...


}
