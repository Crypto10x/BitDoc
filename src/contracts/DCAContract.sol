pragma solidity >0.5.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/math/SafeMath.sol";
import "../contracts/BTCExchange.sol";
import '../contracts/MockBTC.sol';

// We might need contract  factories to contract array for each user
contract DCAContracts {
    
    //general variables
    mapping(address => uint256)  public createdAt;
    mapping(address => address)  public owner; //owner of the contract
    // mapping(address => ERC20)  public token; //setup btc token
    // mapping(address => ERC20) public usd; //dai, usd,bnb
    // mapping(address => uint256) public tokenBalance; //BTC
    MockBTC public token;
    mapping(address => uint256) public usdBalance;

    // == dca setting
    mapping(address => uint256) public usdSize; //size per transaction
    mapping(address => uint256) public startDcaTime; //start of the contract
    mapping(address => uint256) public endDcaTime;
    mapping(address => uint256) public frequencyDays;
    mapping(address => uint256) public depositTime;
    mapping(address => uint256) public buyCount;
    mapping(address => uint256) public penaltyRate;
    mapping(address => uint256) public unlockTime;
    mapping(address => uint256) public penaltyReserves;
    
    // TODO: Create map of pending transactions
    mapping(address => )
    
    // to collect DCA transactions
    mapping(uint => Transactions) public trans;
    struct Transactions {
        uint _id;
        uint usdSize;   
        uint tokenReceived;  
        bool success; // fail if deposit not enough
        uint buyTime;
    }

    //start dca time: buy once ---> wait intervals -> buy next -> until end dca time

    //====time lock varaibles
    // uint256 public unlockTime; // when is the unlock time without
    // uint256 public penaltyRate = 10; // penalty :10 is  10%
    // uint256 public penaltyReserves = 0; // reserves when withdraw

constructor(
    ) public {
        // add required stuff
        // token = ERC20("BTC token address");
        // usd = ERC20("USD token address");
        
        // Commenting
        
        // owner = msg.sender;
        // createdAt = block.timestamp;

        // // dca setting
        // usdSize = _usdSize; //size per transaction
        // startDcaTime = _startDcaTime; //start of the contract
        // endDcaTime =_endDcaTime;
        // frequencyDays =_frequencyDays;
        // //time lock setting
        // depositTime =_startDcaTime;
        // unlockTime =_endDcaTime;
        // usdBalance = _initial_deposit;
        
        
        
        //call buy btc first time too
    }

    function create(
        uint256 _startDcaTime,
        uint256 _endDcaTime,
        uint256 _usdSize,
        uint256 _initial_deposit,
        uint256 _frequencyDays
    ) public {
        // add required stuff
        // token = ERC20("BTC token address");
        // usd = ERC20("USD token address");
        owner[msg.sender] = msg.sender;
        createdAt[msg.sender] = block.timestamp;

        // dca setting
        usdSize[msg.sender] = _usdSize; //size per transaction
        startDcaTime[msg.sender] = _startDcaTime; //start of the contract
        endDcaTime[msg.sender] =_endDcaTime;
        frequencyDays[msg.sender] =_frequencyDays;
        //time lock setting
        depositTime[msg.sender] =_startDcaTime;
        unlockTime[msg.sender] =_endDcaTime;
        usdBalance[msg.sender] = _initial_deposit; // add to MOCKUSD
        
        //call buy btc first time too
    }
    
    function getBalance() public view returns(uint256) {
        return token.balanceOf(msg.sender);
    }


    function buyBtc(address btcExchangeAddress) public{
       // buy btc function 1st time in construct 
        //get btc rate
        uint usdtoken = getBtcRate();

        uint tokenAmount = usdSize[msg.sender] / usdtoken;
        
        //buy btc from exchange
        BTCExchange exchange = new BTCExchange();
        exchange.buyBTC(usdSize[msg.sender]);
        // Transactions storage t = trans[buyCount];

        buyCount[msg.sender] +=1;

    }   


    function relayerBuy(address targetAddress) public{
        // recurring here or have third party execute the contracts

        // can add randomness within days to avoid arbitager
         

    }

    function withDrawUsd() public{
        // no penalty

    }

    function depositUSD(uint256 _amount) public {
        //cannot deposit more than planned
        usdBalance[msg.sender] += _amount;
        
    }

    function withDrawBTC (uint256 _amount) public{
        // if not enough will sell
        usdBalance[msg.sender]-= _amount;

    }

    event BuyBTC(
        address account,
        uint256 index,
        uint256 usd_amount,
        uint256 btc_amount,
        uint256 buyTime
    );
    event SellBTC(
        address account,
        uint256 usd_amount,
        uint256 btc_amount,
        uint256 sellTime
    );
    event WithDrawBTC(
        address account,
        uint256 btc_amount,
        uint256 withDrawTime
    );
    event WithDrawUSD(
        address account,
        uint256 usd_amount,
        uint256 withDrawTime
    );
    event Penalty();

    event DepositETH(address account, uint256 amount, uint256 depositTime);
    event WithdrawETH(
        address account,
        uint256 etherAmount,
        uint256 interest,
        uint256 penalty,
        uint256 withdrawalTime
    );

    modifier onlyOwner {
        require(msg.sender == owner[msg.sender]);
        _;
    }

    function getBtcRate() public view returns(uint256){
        return 50000; // return rates
    }
    

    // deposit ETH
    // function depositETH() public payable {
    //     require(msg.value >= 1e16, "Error, deposit must be >= 0.01 ETH");

    //     ethBalance += msg.value;
    //     depositTime = block.timestamp;

    //     emit DepositETH(msg.sender, msg.value, block.timestamp);
    // }

    // check whether  wil
    function checkPenalty() public view returns (bool) {
        return unlockTime[msg.sender] >= block.timestamp;
    }
    
    
}

    // wit eth with penalty
//     function withdrawETH() public {
//         require(ethBalance >= 0, "Error, no previous deposit");

//         uint256 interest = 0;
//         uint256 penalty = 0;
//         uint256 withdrawBalance = 0;

//         if (checkPenalty() == false) {
//             withdrawBalance = ethBalance;
//             interest = 10;

//             //====== might add interest as DCA  token here
//             //31668017 - interest(10% APY) per second for min. deposit amount (0.01 ETH), cuz:
//             //1e15(10% of 0.01 ETH) / 31577600 (seconds in 365.25 days)
//             //(etherBalanceOf[msg.sender] / 1e16) - calc. how much higher interest will be (based on deposit), e.g.:
//             //for min. deposit (0.01 ETH), (etherBalanceOf[msg.sender] / 1e16) = 1 (the same, 31668017/s)
//             //for deposit 0.02 ETH, (etherBalanceOf[msg.sender] / 1e16) = 2 (doubled, (2*31668017)/s)
//             // uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);
//             // uint interest = interestPerSecond * depositTime;
//         } else {
//             withdrawBalance = (ethBalance * penaltyRate) / 100;
//             penalty = ethBalance - withdrawBalance;
//         }

//         //send funds to user
//         require(address(this).balance >= withdrawBalance);

//         msg.sender.transfer(withdrawBalance); //eth back to user
//         // token.mint(msg.sender, interest); //interest to user

//         ethBalance = 0;
//         penaltyReserves += penalty;

//         emit WithdrawETh(
//             msg.sender,
//             withdrawBalance,
//             interest,
//             penalty,
//             block.timestamp
//         );
//     }

//     //1. Deposit usd

//     function depositUSD(uint256 _usd_amount) public {}

//     //2. Buy BTC with usd

//     //3. Sell BTC with usd, check penalty , transfer usd to user
// }
