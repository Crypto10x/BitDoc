pragma solidity ^0.5.0;

import "./Token.sol";
contract DcaSwap {
    string public name ="Dollar Cost Averaging Crypto Asset";
    Token public token;
    uint public rate =100;
    
    event TokenPurchase(
        address account,
        address token,
        uint amount,
        uint rate
    );

    event TokenSold(
        address account,
        address token,
        uint amount,
        uint rate
    );

    constructor(Token _token) public {
        token = _token;

    }

    function buyTokens() public payable{
        // buy token with fix rate
        uint tokenAmount = msg.value * rate;
        token.transfer(msg.sender,tokenAmount);

        // required that the exhange has enough token
        require(token.balanceOf(address(this)) >= tokenAmount);

        // Emit an event
        emit TokenPurchase(msg.sender,address(token),tokenAmount,rate);

    }

    function sellTokens(uint _amount) public {
        // User cant sell more token than they have
        require(token.balanceOf(msg.sender) >= _amount);

        // calculate eth amount
        uint etherAmount = _amount /rate;

        // required that dcaSwap has enough ether
        require(address(this).balance >= etherAmount);

        // transfer from sender to this contract
        token.transferFrom(msg.sender,address(this),_amount);
        msg.sender.transfer(etherAmount);

        //Emit event
        emit TokenSold(msg.sender,address(token),_amount,rate);



    }
}
