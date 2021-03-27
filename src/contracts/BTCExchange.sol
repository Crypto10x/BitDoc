pragma solidity ^0.5.0;

import "./MockBTC.sol";
import "./MockUSD.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/IERC20.sol";

contract BTCExchange {
    using SafeMath for uint;
     
    string public name ="Mocking DEX exchange for BTC";
    MockBTC public btc=MockBTC(0x417Bf7C9dc415FEEb693B6FE313d1186C692600F);
    MockUSD public usd=MockUSD(0x9bF88fAe8CF8BaB76041c1db6467E7b37b977dD7);
    uint public rate;
    
    event BTCPurchase(
        address account,
        address btc,
        uint amount,
        uint rate
    );

    event BTCPurchase(
        address account,
        address btc,
        uint256 amount,
        uint256 rate
    );

    constructor() public {
        // mintBTC(100000000);
        rate = 55000;  //USDT/BTC

    constructor(MockBTC _btc, MockUSD _usd) public {
        rate = 55000;
        btc = _btc;
        usd = _usd;
    }

    function setRate(uint256 _rate) public {
        rate = _rate;
    }

    //This was to buy with BNB /ETH we should change to DAI
    function buyBTC(uint _usd_amount, address targetAddress) public {
        // buy token with fix rate
        // require(usd.balanceOf(msg.sender) >= _usd_amount);

        uint256 tokenAmount = _usd_amount.div(rate);

        // required that the exhange has enough token
        // require(btc.balanceOf(address(this)) >= tokenAmount);
        btc.allowance(address(this), targetAddress);
        btc.transferFrom(address(this),targetAddress,tokenAmount);
        
        // usd.allowance(msg.sender, address(this));
        // usd.transferFrom(msg.sender,address(this),_usd_amount);

        // // Emit an event
        emit BTCPurchase(targetAddress,address(btc),tokenAmount,rate);

    }

    function mintBTC(uint256 _amount) public {
        btc.mint(_amount);
    }

    function checkBTC() public view returns (uint256) {
        return btc.balanceOf(address(this));
    }

    function checkUSD() public view returns (uint256) {
        return usd.balanceOf(address(this));
    }

    // function sellBTC(uint _btc_amount) public payable{
    //     // User cant sell more token than they have
    //     require(btc.balanceOf(msg.sender) >= _btc_amount);

    //     // calculate USD amount
    //     uint usdAmount = _btc_amount.mul(rate);

    //     // required that dcaSwap has enough ether
    //     require(usd.balanceOf(address(this)) >= usdAmount);

    //     // transfer from sender to this contract
    //     btc.transferFrom(msg.sender,address(this),_btc_amount);

    //     usd.transferFrom(address(this),msg.sender,usdAmount);

    //     //Emit event
    //     emit BTCSold(msg.sender,address(btc),_btc_amount,rate);

    // }
}
