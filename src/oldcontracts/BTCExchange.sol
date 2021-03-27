pragma solidity ^0.5.0;

import "./MockBTC.sol";
import "./MockDAI.sol";
// import "./SafeMath.sol";

contract BTCExchange {
    using SafeMath for uint;
     
    string public name ="Mocking DEX exchange for BTC";
    MockBTC public btc;
    MockDAI public dai;
    uint public rate;
    
    event BTCPurchase(
        address account,
        address btc,
        uint amount,
        uint rate
    );

    event BTCSold(
        address account,
        address btc,
        uint amount,
        uint rate
    );

    constructor(uint _mint_vol,MockBTC _btc, MockDAI _dai) public {
        btc =_btc;
        dai =_dai;
        
        // btc.mint(_mint_vol);
        rate = 5+_mint_vol;  //USDT/BTC

    }
    
    function setRate(uint _rate) public {
        rate =_rate;
    }
    
    //This was to buy with BNB /ETH we should change to DAI
    function buyBTC(uint _dai_amount) public {
        // buy token with fix rate
        require(dai.balanceOf(msg.sender) >= _dai_amount); // not  sure why cannot buy btc????

        uint tokenAmount = _dai_amount.div(rate);
        
        // required that the exhange has enough token
        require(btc.balanceOf(address(this)) >= tokenAmount);
        
        
        btc.transferFrom(address(this),msg.sender,tokenAmount);

        dai.transferFrom(msg.sender,address(this),_dai_amount);

        // Emit an event
        emit BTCPurchase(msg.sender,address(btc),tokenAmount,rate);

    }
    function mintBTC(uint _amount) public{
        // btc.mint(_amount);

    }
    
    function checkBTC() public view returns (uint) {
        return btc.balanceOf(address(this));
    }
    
    function checkDAI() public view returns (uint) {
        return dai.balanceOf(address(this));
    }
     

    function sellBTC(uint _btc_amount) public {
        // User cant sell more token than they have
        require(btc.balanceOf(msg.sender) >= _btc_amount);

        // calculate USD amount
        uint daiAmount = _btc_amount.mul(rate);

        // required that dcaSwap has enough ether
        require(dai.balanceOf(address(this)) >= daiAmount);

        // transfer from sender to this contract
        btc.transferFrom(msg.sender,address(this),_btc_amount);
        
        dai.transferFrom(address(this),msg.sender,daiAmount);

        //Emit event
        emit BTCSold(msg.sender,address(btc),_btc_amount,rate);



    }
}
