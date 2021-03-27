pragma solidity ^0.5.0;


import "./MintableERC20.sol";


contract MockBTC is MintableERC20 {

    uint256 public decimals = 18;
    string public symbol = "BTC";
    string public name = "Bitcoin";
}