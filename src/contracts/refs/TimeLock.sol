pragma solidity >0.5.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/math/SafeMath.sol";
contract TimeLockedWallet {
    // address public owner;
    uint256 public unlockTime;
    uint256 public createdAt;
    uint256 public depositTime;
    // uint256 public hodlPeriod;
    uint256 public ethBalance;
    uint256 public penaltyRate; // penalty in ratio like 0.1 => 10%
    uint256 public penaltyReserves;
    address payable owner = msg.sender;

    event DepositETH(address account, uint256 amount, uint256 depositTime);
    event Withdraw(
        address account,
        uint256 etherAmount,
        uint256 interest,
        uint256 penalty,
        uint256 withdrawalTime
    );

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor(uint256 _unlockTime) public {
        // require(_unlockTime >block.timestamp);
        owner = msg.sender;
        unlockTime = _unlockTime;
        // depositTime = block.timestamp - depositStart[msg.sender];
        createdAt = block.timestamp;
        ethBalance = 0;
        penaltyRate = 10;
        penaltyReserves = 0;
    }

    function deposit() public payable {
        require(msg.value >= 1e16, "Error, deposit must be >= 0.01 ETH");

        ethBalance += msg.value;
        depositTime = block.timestamp;

        emit DepositETH(msg.sender, msg.value, block.timestamp);
    }

    function checkPenalty() public view returns (bool) {
        return unlockTime >= block.timestamp;
    }

    function withdraw() public {
        require(ethBalance >= 0, "Error, no previous deposit");

        uint256 interest = 0;
        uint256 penalty = 0;
        uint256 withdrawBalance = 0;

        if (checkPenalty() == false) {
            withdrawBalance = ethBalance;
            interest = 10;

            //might add interest
            //31668017 - interest(10% APY) per second for min. deposit amount (0.01 ETH), cuz:
            //1e15(10% of 0.01 ETH) / 31577600 (seconds in 365.25 days)

            //(etherBalanceOf[msg.sender] / 1e16) - calc. how much higher interest will be (based on deposit), e.g.:
            //for min. deposit (0.01 ETH), (etherBalanceOf[msg.sender] / 1e16) = 1 (the same, 31668017/s)
            //for deposit 0.02 ETH, (etherBalanceOf[msg.sender] / 1e16) = 2 (doubled, (2*31668017)/s)
            // uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);
            // uint interest = interestPerSecond * depositTime;
        } else {
            withdrawBalance = (ethBalance * penaltyRate) / 100;
            penalty = ethBalance - withdrawBalance;
        }

        //send funds to user
        require(address(this).balance >= withdrawBalance);

        msg.sender.transfer(withdrawBalance); //eth back to user
        // token.mint(msg.sender, interest); //interest to user

        ethBalance = 0;
        penaltyReserves += penalty;

        emit Withdraw(
            msg.sender,
            withdrawBalance,
            interest,
            penalty,
            block.timestamp
        );
    }
}
