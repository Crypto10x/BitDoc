pragma solidity >0.5.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TimeLockedWallet {

    address public creator;
    address public owner;
    uint256 public unlockTime;
    uint256 public createdAt;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor(
        address _creator,
        address _owner,
        uint256 _unlockTime
    ) public {
        require(_unlockTime >block.timestamp);
        creator = _creator;
        owner = _owner;
        unlockTime = _unlockTime;
        createdAt = now;
    }

}


