pragma solidity ^0.4.23;

contract Casino {
    address manager;
    uint public minimumBet;
    uint public lastNumberWinner;
    struct Info {
        uint number;
        uint money;
        bool alreadyBet;
    }

    uint public maxAllowBets = 10;
    uint public numberOfBets;

    uint public totalMoney;
    mapping(address => Info) public PlayersInfo;
    address[] public Players;

    constructor (uint _minimumBet, uint _maxAllowBets) public {
        manager = msg.sender;
        minimumBet = _minimumBet; // ether
        maxAllowBets = _maxAllowBets;
    }

    function bet(uint _number) public payable {
        require(msg.sender != manager); // not allow manager to bet
        require(msg.value >= minimumBet);
        require(!isPlayerAlreadyBet());
        // we can also loop through Players to check if a user
        // is already bet ot not, but it cost more gas


	    require(_number >= 1 && _number <= 10);
        Info memory info;
        info.number = _number;
        info.money = msg.value;
        info.alreadyBet = true;
        PlayersInfo[msg.sender] = info;
        Players.push(msg.sender);
        totalMoney+= msg.value;
        numberOfBets++;
        if(numberOfBets >= maxAllowBets){
            finalizeResult();
        }
    }


    function finalizeResult () public {
        require(msg.sender == manager);
        // uint resultNumber = random();
         uint resultNumber = 1;

        uint numberOfUserChoseTheRightNumber;
        uint totalValueOfUserChoseRight;
        (
        numberOfUserChoseTheRightNumber,
        totalValueOfUserChoseRight
        ) = getResultsInfo(resultNumber);
        distributeMoney(totalValueOfUserChoseRight, resultNumber);
        lastNumberWinner = resultNumber;
    }

    function random() private view returns (uint8) {
     return uint8(uint256(keccak256(block.timestamp, block.difficulty))%10);
    }

    function getResultsInfo (uint _resultNumber) public view returns (uint, uint){
        uint numberOfUserChoseTheRightNumber = 0;
        uint totalValueOfUserChoseRight = 0;
        for (uint i = 0; i < Players.length; i ++) {
            address addressUser = Players[i];

            if(PlayersInfo[addressUser].number == _resultNumber){
                numberOfUserChoseTheRightNumber++;
                totalValueOfUserChoseRight+= PlayersInfo[addressUser].money;
            }
        }
        return (
            numberOfUserChoseTheRightNumber,
            totalValueOfUserChoseRight
        );
    }

    function distributeMoney(uint _totalValueOfUserChoseRight, uint _resultNumber) private {

        for (uint i = 0; i < Players.length; i ++) {
            address addressUser = Players[i];

            if(PlayersInfo[addressUser].number == _resultNumber){

            uint money = (totalMoney * PlayersInfo[addressUser].money) / _totalValueOfUserChoseRight;
            addressUser.transfer(money);
            delete PlayersInfo[addressUser];
            }

        }
        resetBalance();
        totalMoney = 0;

        delete Players;
    }


    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function resetBalance() public returns (uint) {
        // if atleast one users chosen a correct number, the contract balance will be 0
        // transfer all ether in this contract to manager (when none choosen the right number)
        uint balance = getBalance();
        manager.transfer(balance);

    }



    function isPlayerAlreadyBet() public view returns (bool) {
        return PlayersInfo[msg.sender].alreadyBet;
    }

    function getPlayerBetInfo() public view returns (uint, uint) {
        require(isPlayerAlreadyBet());
        uint number = PlayersInfo[msg.sender].number;
        uint money = PlayersInfo[msg.sender].money;
        return (
            number,
            money
        );
    }
}
