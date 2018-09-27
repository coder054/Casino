pragma solidity ^0.4.0;

contract Casino {

    event FinaliseResult(uint resultNumber);
    event Bet(address add,uint money, uint number);

    address manager;
    uint public lastWinnerNumer;
    uint public minimumMoney;
    uint public maxAllowBets = 10;
    uint public totalBets;
    struct Info {
        uint number;
        uint moneyBet;
        bool alreadyChosen;
    }

    uint public totalMoney;
    mapping(address => Info) public usersInfo;
    address[] public allUsers;

    constructor(uint _minimumMoney, uint _maxAllowBets) public {
        manager = msg.sender;
        minimumMoney = _minimumMoney; // ether
        maxAllowBets = _maxAllowBets;

    }

    function chooseNumber(uint _number) public payable {
        require(msg.value >= minimumMoney);
        require(!_isAlreadyBet(msg.sender));
        Info memory info;
        info.number = _number;
        info.moneyBet = msg.value;
        info.alreadyChosen = true;
        usersInfo[msg.sender] = info;
        allUsers.push(msg.sender);
        totalMoney+= msg.value;
        totalBets++;
        emit Bet(msg.sender, msg.value, _number) ;
        if(totalBets >= maxAllowBets){
            finalizeResult();
        }
    }



    function finalizeResult () public {
        uint resultNumber = _random();
        // uint resultNumber = 1;
        uint numberOfUserChoseTheRightNumber;
        uint totalValueOfUserChoseRight;
        (
            numberOfUserChoseTheRightNumber,
            totalValueOfUserChoseRight
        ) = _getResultsInfo(resultNumber);
        _distributeMoney(totalValueOfUserChoseRight, resultNumber);
        lastWinnerNumer = resultNumber;
        emit FinaliseResult(resultNumber);
    }



    function _getResultsInfo (uint _resultNumber) private view returns (uint, uint){
        uint numberOfUserChoseTheRightNumber = 0;
        uint totalValueOfUserChoseRight = 0;
        for (uint i = 0; i < allUsers.length; i ++) {
            address addressUser = allUsers[i];

            if(usersInfo[addressUser].number == _resultNumber){
                numberOfUserChoseTheRightNumber++;
                totalValueOfUserChoseRight+= usersInfo[addressUser].moneyBet;
            }
        }
        return (
            numberOfUserChoseTheRightNumber,
            totalValueOfUserChoseRight
        );
    }

    function _distributeMoney(uint _totalValueOfUserChoseRight, uint _resultNumber) private {
        for (uint i = 0; i < allUsers.length; i ++) {
            address addressUser = allUsers[i];

            if(usersInfo[addressUser].number == _resultNumber){

                uint money = (totalMoney * usersInfo[addressUser].moneyBet) / _totalValueOfUserChoseRight;
                addressUser.transfer(money);
                delete usersInfo[addressUser];
            }

        }

        uint balance = getBalance();
        manager.transfer(balance); // if none is winner, transfer all ether to manager, the balance of contract is reset
        totalMoney = 0;

        delete allUsers;
    }

    function _isAlreadyBet(address _add) private view returns (bool) {
          return usersInfo[_add].alreadyChosen;
        // we can also loop through allPlayers to check. But it cost more gas.
        // That the purpose of alreadyChosen property
    }

    // function getBetInfo() public view returns (bool, uint, uint) {

    //     if(!_isAlreadyBet(msg.sender)){
    //         return (false, 0 , 0);
    //     }else{
    //         return (
    //         true,  usersInfo[msg.sender].number, usersInfo[msg.sender].moneyBet
    //         );
    //     }
    // }

    function getBetInfo(address _add) public view returns (bool, uint, uint) {

        if(!_isAlreadyBet(_add)){
            return (false, 0 , 0);
        }else{
            return (
            true,  usersInfo[_add].number, usersInfo[_add].moneyBet
            );
        }
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function _random() private view returns (uint8) {
        return uint8(uint256(keccak256(block.timestamp, block.difficulty))%10);
    }

}
